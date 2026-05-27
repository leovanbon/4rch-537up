#!/bin/bash

# Get a list of the names of all windows in the scratchpad
mapfile -t scratchpad_windows < <(swaymsg -t get_tree | jq -r '.. | select(.name? == "__i3_scratch") | .floating_nodes | .[] | .name')

count=${#scratchpad_windows[@]}

# If the scratchpad has windows...
if [ "$count" -gt 0 ]; then
    # ...create a tooltip listing each window on a new line
    tooltip=""
    for window in "${scratchpad_windows[@]}"; do
        tooltip+="$window\n"
    done
    
    # Format the JSON output for Waybar
    # Text: An icon and the number of windows
    # Tooltip: The list of window names
    printf '{"text": " %s", "tooltip": "%s"}' "$count" "$tooltip"
else
    # If the scratchpad is empty, print nothing so the module hides
    echo ""
fi
