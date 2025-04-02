#!/usr/bin/env bash

# Get the active workspace ID
active_workspace=$(hyprctl activeworkspace -j | jq '.id')

# Get the active window address before we start
active_window=$(hyprctl activewindow -j | jq -r '.address')

# Get all windows in the active workspace and store them in an array
windows=($(hyprctl clients -j | jq --arg ws "$active_workspace" '.[] | select(.workspace.id == ($ws|tonumber)) | .address'))

# Count grouped windows
grouped_count=0
for window in "${windows[@]}"; do
    # Remove the quotes from the window address
    window=${window//\"/}
    
    # Check if window is grouped by checking if grouped array is non-empty
    is_grouped=$(hyprctl clients -j | jq --arg addr "$window" '.[] | select(.address == $addr) | (.grouped | length > 0)')
    
    if [ "$is_grouped" = "true" ]; then
        # Activate the window first
        hyprctl dispatch focuswindow "address:$window"
        
        # Ungroup the window using hyprctl
        hyprctl dispatch moveoutofgroup
        ((grouped_count++))
    fi
done

# Get all windows in the active workspace and store them in an array, sorted by x position
windows=($(hyprctl clients -j | jq --arg ws "$active_workspace" \
    '.[] | select(.workspace.id == ($ws|tonumber)) | [.address, .at[0]] | @csv' | \
    sort -t',' -k2 -n | cut -d',' -f1))

# Now group all windows together
if [ ${#windows[@]} -gt 1 ]; then  # Only proceed if there are at least 2 windows
    # Focus the first window (leftmost) to start the group
    first_window=${windows[0]//\"/}  # Remove quotes
    first_window=${first_window//\\/}  # Remove backslashes
    
    hyprctl dispatch focuswindow "address:$first_window"

    # Create a new group with the first window
    hyprctl dispatch togglegroup

    # Add all other windows to the group in order of x position
    for ((i=1; i<${#windows[@]}; i++)); do
        window=${windows[$i]//\"/}  # Remove quotes
        window=${window//\\/}  # Remove backslashes
        
        hyprctl dispatch focuswindow "address:$window"
        hyprctl dispatch moveintogroup l
    done

    # Focus back to the originally active window
    active_window=${active_window//\\/}  # Remove backslashes
    hyprctl dispatch focuswindow "address:$active_window"
    echo "Grouped ${#windows[@]} windows together"
fi

