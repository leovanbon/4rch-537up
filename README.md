# Arch Sway Setup

Personal Arch Linux desktop bootstrap for a Sway/Wayland setup.

This repo installs the desktop packages, links dotfiles with GNU Stow, and enables the core services needed for the session.

## What It Sets Up

- Sway window manager
- Waybar bottom bar
- Fuzzel app launcher and power menu
- Swayr window switcher
- Kitty terminal
- Dunst notifications
- Cliphist clipboard picker
- Swaylock lock screen
- Swaybg wallpaper
- PipeWire/WirePlumber audio
- NetworkManager and Bluetooth applets
- Fcitx5 Vietnamese input
- Zsh with autosuggestions and syntax highlighting

## Repo Layout

```text
.
├── dotfiles/          # Stow packages linked into $HOME
├── optional/          # Machine-specific configs to copy manually if needed
├── packages/
│   ├── pacman.txt     # Official repo packages
│   └── aur.txt        # AUR packages
└── setup.sh           # Bootstrap script
```

## First Push To GitHub

Create an empty GitHub repo first, then run:

```bash
cd ~/arch-sway-setup
git init
git branch -M main
git add .
git commit -m "Initial Arch Sway setup"
git remote add origin git@github.com:YOUR_USERNAME/arch-sway-setup.git
git push -u origin main
```

Use a private repo if you expect to add machine-specific paths, personal scripts, or anything that could expose local details.

## Install On A New Arch Machine

After a base Arch install and a normal user account:

```bash
sudo pacman -Syu --needed git
git clone git@github.com:YOUR_USERNAME/arch-sway-setup.git
cd arch-sway-setup
./setup.sh
reboot
```

If SSH keys are not set up yet, use HTTPS:

```bash
git clone https://github.com/YOUR_USERNAME/arch-sway-setup.git
```

## After Install

Log in through `ly` and start Sway.

If monitor layout is wrong, run:

```bash
nwg-displays
```

or edit:

```text
~/.config/sway/outputs
```

The files in `optional/` are from the original machine. Copy them only when the new PC has the same monitor layout and ICC profile paths.

## Notes

- `setup.sh` backs up existing configs into `~/.dotfiles-backup/<timestamp>/`.
- The repo intentionally does not copy the original full `.zshrc`, because that file contained secret-looking environment values.
- Wallpaper defaults to a black background. Put your image paths in `~/.azotebg` after install.
- `swayr` is listed in `packages/aur.txt`; the script installs `yay-bin` if AUR packages are enabled and `yay` is missing.
