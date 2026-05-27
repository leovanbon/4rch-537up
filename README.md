# Arch Sway Setup

Personal Arch Linux desktop bootstrap for a Sway/Wayland setup.

<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/eb24f312-382b-4480-91f0-e14eb2ff4755" />

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

## Install On A New Arch Machine

After a base Arch install and a normal user account, clone this repo and run `setup.sh`

## Notes

- `setup.sh` backs up existing configs into `~/.dotfiles-backup/<timestamp>/`.
- Wallpaper defaults to a black background. Put your image paths in `~/.azotebg` after install (can be set up with `Azote`).
- `swayr` is listed in `packages/aur.txt`; the script installs `yay-bin` if AUR packages are enabled and `yay` is missing.
- Review the shortcuts in `~/.config/sway/config`.
