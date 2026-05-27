#!/bin/sh

chosen=$(printf "  shutdown\n  restart\n  leave" | fuzzel --dmenu \
    --anchor=bottom-left --x-margin=0 --y-margin=0 \
    --lines=3 --width=15 \
    --font="monospace:size=9" \
    --background=000000ff \
    --text-color=ffffffff \
    --selection-color=ffffffff \
    --selection-text-color=000000ff \
    --border-width=0 \
    --prompt-color=ffffffff \
    --prompt="exit:")

case "$chosen" in
    "  shutdown") systemctl poweroff ;;
    "  restart") systemctl reboot ;;
    "  leave") swaymsg exit ;;

    *) exit 1 ;;
esac
