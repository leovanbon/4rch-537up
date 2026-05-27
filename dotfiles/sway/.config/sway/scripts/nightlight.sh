#!/bin/bash

# Path to a temporary file to store the current state
STATE_FILE="/tmp/gammastep_state"

# Define your temperatures (Windows equivalents)
# 6500 = Off, 4500 = Soft, 3400 = Windows Default Night Light
PRESETS=(6500 4500 3400)

# Read the current state (default to 0 if file doesn't exist)
if [ ! -f "$STATE_FILE" ]; then
    echo 0 > "$STATE_FILE"
fi

CURRENT_INDEX=$(cat "$STATE_FILE")

# Calculate the next preset index
NEXT_INDEX=$(( (CURRENT_INDEX + 1) % ${#PRESETS[@]} ))
TEMP=${PRESETS[$NEXT_INDEX]}

# Apply the temperature
pkill -x gammastep # Kill any existing instance
if [ "$TEMP" -eq 6500 ]; then
    gammastep -x
    # Use -h string:x-dunst-stack-tag to replace the previous notification
    notify-send -h string:x-dunst-stack-tag:gammastep "Night Light" "Mode: Off (6500K)" -i display
else
    gammastep -O "$TEMP" &>/dev/null &
    notify-send -h string:x-dunst-stack-tag:gammastep "Night Light" "Mode: $TEMP K" -i display
fi
# Save the new state
echo "$NEXT_INDEX" > "$STATE_FILE"