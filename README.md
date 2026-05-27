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

## Install On A New Arch Machine

After a base Arch install and a normal user account, clone this repo and run `setup.sh`

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
- Wallpaper defaults to a black background. Put your image paths in `~/.azotebg` after install (can be set up with `Azote`).
- `swayr` is listed in `packages/aur.txt`; the script installs `yay-bin` if AUR packages are enabled and `yay` is missing.
