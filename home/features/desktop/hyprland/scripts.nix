{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: let
  # use OCR and copy to clipboard
  ocrScript = let
    inherit (pkgs) grim libnotify slurp tesseract5 wl-clipboard;
    _ = lib.getExe;

    moveWindowsFile = builtins.readFile "scripts/moveWindows.sh";
  in
    pkgs.writeShellScriptBin "wl-ocr" ''
      ${_ grim} -g "$(${_ slurp})" -t ppm - | ${_ tesseract5} - - | ${wl-clipboard}/bin/wl-copy
      ${_ libnotify} "$(${wl-clipboard}/bin/wl-paste)"
    '';

  moveWindows = pkgs.writeShellScriptBin "hypeMoveMonitors" ''
    #!/bin/sh
    function handle {
        if [[ ''${1:0:10} == "openwindow" ]]; then
            #
            # Move YouTube Music to workspace special workspace when opened
            #
            sleep 2
            json_output=$(hyprctl clients -j)
            address=''${1:12:7}
            title=$(echo "$json_output" | jq '.[] | select(.address == "0x'$address'") | .title')
            echo
            if [[ $title == "\"Music — Mozilla Firefo\"" ]]; then
                hyprctl dispatch movetoworkspace special:music,address:0x''${1:12:7}
            fi
        fi
    }
    socat -t 1000 -U - UNIX-CONNECT:/tmp/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock  | while read line; do handle $line; done
  '';

  hyprlandWorkspaceMonitorFix = pkgs.writeShellScriptBin "hyprlandWorspaceMonitorFix" ''
    #!/bin/sh
    function handle {
      if [[ ''${1:0:12} == "monitoradded" ]]; then
        hyprctl dispatch moveworkspacetomonitor 1 DP-2 && hyprctl dispatch moveworkspacetomonitor 2 DP-2 && hyprctl dispatch moveworkspacetomonitor 3 DP-2 && hyprctl dispatch moveworkspacetomonitor 4 DP-2 && hyprctl dispatch moveworkspacetomonitor 5 DP-2 && hyprctl dispatch moveworkspacetomonitor 6 DP-3 && hyprctl dispatch moveworkspacetomonitor 7 DP-3 && hyprctl dispatch moveworkspacetomonitor 8 DP-3 && hyprctl dispatch moveworkspacetomonitor 9 DP-3 && hyprctl dispatch moveworkspacetomonitor 10 DP-2
        hyprctl dispatch workspace 1 && hyprctl dispatch workspace 2 && hyprctl dispatch workspace 3 && hyprctl dispatch workspace 4 && hyprctl dispatch workspace 5 && hyprctl dispatch workspace 6 && hyprctl dispatch workspace 7 && hyprctl dispatch workspace 8 && hyprctl dispatch workspace 9 && hyprctl dispatch workspace 10 && hyprctl dispatch workspace 6 && hyprctl dispatch workspace 1 && $statusbar
      fi
    }
    socat - UNIX-CONNECT:/tmp/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock  | while read line; do handle $line; done
  '';

  hyprlandPerWindowLayout = pkgs.writeShellScriptBin "hyprlandPerWindowLayout" ''

    #!/usr/bin/env bash
    #
    # Hyprland per window xkb layout
    #
    # How it works:
    #
    # At script's launch every window (if any) gets its defined layout as currently selected.
    #
    # When new windows is opened the current layout is used.
    # When existing window is selected - its defined layout is used.

    set -e

    print_debug() {
        if ''$DEBUG; then
            if command -v lolcat >/dev/null; then
                echo -e "''$@" | lolcat
            else
                echo -e "LOG:" "''$@"
            fi
        fi
    }

    echons() {
        echo "''$1"
        notify-send "Hyprland per window xkblayout:" "''$1"
    }

    # OPTIONS (...are guessed automatically if there is no config)
    DEBUG="''${HPWX_DEBUG:-false}"
    keyboard="your-keyboard-name-with-no-spaces-all-lowercase"
    declare -A layouts_short

    #
    # -------------------------------------------------------
    #

    config="''$HOME/.config/hypr/xkb_layout.conf"
    if [[ -f "''$config" ]]; then
        print_debug "loaded config from ''${config}\n"
        source "''$config"

        kbd="''$(hyprctl devices -j | gojq -r ".keyboards | .[] | select(.name == \"''$keyboard\")")"
        if [[ "''$kbd" == "" ]]; then
            echons "No such device - '''$keyboard'"
            exit 1
        fi
    else
        print_debug "no config file, trying to guess options..."

        # Find keyboards that have multiple layouts defined,
        # pick the first one of them, because if you have
        # multiple keyboards with different layouts - you're
        # obviously know what you're doing and don't need this script.
        keyboard="''$(hyprctl devices -j |
            gojq -r ".keyboards | .[] | select(.layout | contains(\",\")) | .name" |
            head -n 1)"
        if [[ "''$keyboard" == "" ]]; then
            echons "No keyboard with multiple layouts defined found"
            exit 1
        fi
    fi

    # FIXME eww this looks horrible {{{
    # kb_layout, but as an array that we can index
    read -r -a kb_layout_arr < <(
        hyprctl devices -j |
            gojq -r ".keyboards | .[] | select(.name == \"''$keyboard\") | .layout" |
            tr ',' ' '
    )

    layout_long="''$(hyprctl devices -j |
        gojq -r ".keyboards | .[] | select(.name == \"''$keyboard\") | .active_keymap")"

    # short layout names to index
    declare -A kb_layout
    for index in "''${!kb_layout_arr[@]}"; do
        # inverse
        short_name="''${kb_layout_arr["''$index"]}"
        kb_layout["''$short_name"]="''$index"

        if ! [[ -f "''$config" ]]; then
            # find long names
            hyprctl switchxkblayout "''$keyboard" "''$index"
            long_name="''$(hyprctl devices -j |
                gojq -r ".keyboards | .[] | select(.name == \"''$keyboard\") | .active_keymap")"

            layouts_short["''$long_name"]="''$short_name"

            print_debug "found layout: '''$short_name' (''$index) is '''$long_name'"
        fi
    done

    layout="''${layouts_short["''$layout_long"]}"

    index="''${kb_layout[''$layout]}"
    hyprctl switchxkblayout "''$keyboard" "''$index"

    # }}}

    # addr to layout map
    declare -A windows

    # predefine current layout for all windows
    for addr in ''$(hyprctl clients -j | gojq -r '.[] | .address'); do
        windows[''$addr]="''$layout"
        print_debug "define window ''$addr layout as '''$layout'"
    done

    # to ignore `activelayout` events generated by script itself
    from_script=false

    handle() {
        event="''${1%%>>*}"
        event_data="''${1##*>>}"

        if ''$DEBUG; then
            echo "''$1"
        fi

        case "''$event" in
        activelayout)
            local current="''$(hyprctl activewindow -j | gojq -r '.address')"

            local kbd_device="''${event_data%,*}"
            local layout_fullname="''${event_data#*,}"

            if ! [[ -v layouts_short["''$layout_fullname"] ]] ||
                [[ "''$kbd_device" != "''$keyboard" ]]; then
                # layout can also be `error` or `none`
                # happens after using `wtype`
                return
            fi

            layout="''${layouts_short["''$layout_fullname"]}"

            if [[ "''$current" == null ]]; then
                return
            fi
            if ''$from_script; then
                from_script=false
                return
            fi

            windows["''$current"]="''$layout"

            print_debug "define layout for window ''$current as '''$layout'"
            ;;

        openwindow)
            local open_addr="0x''${event_data%%,*}"
            windows["''$open_addr"]="''$layout"
            print_debug "open window ''$open_addr, define layout as '''$layout'"
            ;;

        activewindow)
            local current="''$(hyprctl activewindow -j | gojq -r '.address')"

            if [[ -v windows["''$current"] ]]; then
                # loading saved layout
                local short="''${windows[''$current]}"
                local index="''${kb_layout[''$short]}"

                print_debug "window ''$current with defined layout '''$short' (current is '''$layout')"

                if [[ "''$layout" == "''$short" ]]; then
                    return
                fi

                from_script=true
                hyprctl switchxkblayout "''$keyboard" "''$index"

                layout="''$short"
                print_debug "RESTORED layout '''$short' (''$index)"
            else
                print_debug "window ''$current without saved layout? WTF"
            fi
            ;;

        closewindow)
            local close_addr="0x''${event_data}"
            unset windows["''$close_addr"]
            print_debug "clear window ''$close_addr from map"
            ;;
        esac
    }

    print_debug "\nOptions set:\n"

    print_debug "DEBUG = ''$DEBUG, keyboard = '''$keyboard'"
    print_debug "Long layout names to short names:"
    print_debug "    ''$(declare -p layouts_short)"
    print_debug "Index of a given layout in Hyprland's 'kb_layout':"
    print_debug "    ''$(declare -p kb_layout)"

    print_debug "\n...waiting for new events...\n"

    hl_instance="/tmp/hypr/''$HYPRLAND_INSTANCE_SIGNATURE"

    socat - \
        UNIX-CONNECT:"''$hl_instance/.socket2.sock" |
        while read -r line; do
            handle "''$line"
        done

    # vim:foldmethod=marker


  '';
in {
  home.packages = [
    pkgs.socat
    pkgs.gojq
    hyprlandPerWindowLayout
    # hyprlandWorkspaceMonitorFix
    moveWindows
    ocrScript
  ];

  programs = {
    fish.loginShellInit = ''
      if test (tty) = "/dev/tty1"
        exec Hyprland &> /dev/null
      end
    '';
  };
}
