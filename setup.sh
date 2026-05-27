#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
backup_dir="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

info() {
  printf '\033[1;34m==>\033[0m %s\n' "$*"
}

warn() {
  printf '\033[1;33mwarning:\033[0m %s\n' "$*" >&2
}

require_arch() {
  if ! command -v pacman >/dev/null 2>&1; then
    printf 'This installer expects Arch Linux with pacman.\n' >&2
    exit 1
  fi
}

read_package_list() {
  local file="$1"
  sed -e 's/#.*$//' -e '/^[[:space:]]*$/d' "$file"
}

install_pacman_packages() {
  mapfile -t packages < <(read_package_list "$repo_dir/packages/pacman.txt")
  if ((${#packages[@]})); then
    info "Installing pacman packages"
    sudo pacman -Syu --needed "${packages[@]}"
  fi
}

install_yay_if_needed() {
  if command -v yay >/dev/null 2>&1; then
    return
  fi

  info "Installing yay-bin from AUR"
  local build_dir
  build_dir="$(mktemp -d)"
  git clone https://aur.archlinux.org/yay-bin.git "$build_dir/yay-bin"
  (
    cd "$build_dir/yay-bin"
    makepkg -si --noconfirm
  )
}

install_aur_packages() {
  mapfile -t aur_packages < <(read_package_list "$repo_dir/packages/aur.txt")
  if ((${#aur_packages[@]})); then
    install_yay_if_needed
    if command -v yay >/dev/null 2>&1; then
      info "Installing AUR packages"
      yay -S --needed "${aur_packages[@]}"
    fi
  fi
}

backup_path() {
  local target="$1"
  local relative="${target#$HOME/}"
  local destination="$backup_dir/$relative"

  mkdir -p "$(dirname "$destination")"
  mv "$target" "$destination"
  info "Backed up $target -> $destination"
}

backup_existing_dotfiles() {
  local targets=(
    "$HOME/.config/sway"
    "$HOME/.config/waybar"
    "$HOME/.config/fuzzel"
    "$HOME/.config/swayr"
    "$HOME/.config/kitty"
    "$HOME/.config/dunst"
    "$HOME/.config/systemd/user/swayrd.service"
    "$HOME/.azotebg"
    "$HOME/.zshenv"
    "$HOME/.zprofile"
    "$HOME/.zshrc"
  )

  for target in "${targets[@]}"; do
    if [[ -e "$target" || -L "$target" ]]; then
      if [[ -L "$target" ]]; then
        local link_target
        link_target="$(readlink "$target")"
        case "$link_target" in
          "$repo_dir"/dotfiles/*|../arch-sway-setup/dotfiles/*)
            continue
            ;;
        esac
      fi
      backup_path "$target"
    fi
  done
}

link_dotfiles() {
  info "Linking dotfiles with stow"
  mkdir -p "$HOME/.config"
  stow --dir="$repo_dir/dotfiles" --target="$HOME" sway waybar fuzzel swayr kitty dunst zsh azote systemd
}

enable_services() {
  info "Enabling system services"
  sudo systemctl enable NetworkManager.service
  sudo systemctl enable bluetooth.service
  sudo systemctl enable ly.service

  info "Enabling user services"
  systemctl --user enable pipewire.service pipewire-pulse.service wireplumber.service || true
  if command -v swayrd >/dev/null 2>&1; then
    systemctl --user enable swayrd.service || true
  fi
}

set_shell() {
  if [[ "${SHELL:-}" != */zsh ]] && command -v zsh >/dev/null 2>&1; then
    info "Changing login shell to zsh"
    chsh -s "$(command -v zsh)" || warn "Could not change shell automatically"
  fi
}

main() {
  require_arch
  install_pacman_packages
  install_aur_packages
  backup_existing_dotfiles
  link_dotfiles
  enable_services
  set_shell

  info "Done. Reboot, then choose/start the Sway session from ly."
  info "If monitor layout is wrong, run nwg-displays or edit ~/.config/sway/outputs."
}

main "$@"
