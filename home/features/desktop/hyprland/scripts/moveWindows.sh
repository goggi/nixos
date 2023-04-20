    #!/bin/sh
    function handle {
        if [[ ''${1:0:10} == "openwindow" ]]; then
            #
            # Move YouTube Music to workspace special workspace when opened
            #
            sleep 1
            json_output=$(hyprctl clients -j)
            address=''${1:12:7}
            title=$(echo "$json_output" | jq '.[] | select(.address == "0x'$address'") | .title')
            echo
            if [[ $title == "\"YouTube Music — Mozilla Firefox\"" ]]; then
                hyprctl dispatch movetoworkspace special:music,address:0x''${1:12:7}
            fi
        fi
    }
    socat - UNIX-CONNECT:/tmp/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock  | while read line; do handle $line; done