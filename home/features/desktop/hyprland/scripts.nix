{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: let
  #   # use OCR and copy to clipboard
  #   ocrScript = let
  #     inherit (pkgs) grim libnotify slurp tesseract5 wl-clipboard;
  #     _ = lib.getExe;
  #     moveWindowsFile = builtins.readFile "scripts/moveWindows.sh";
  #   in
  #     pkgs.writeShellScriptBin "wl-ocr" ''
  #       ${_ grim} -g "$(${_ slurp})" -t ppm - | ${_ tesseract5} - - | ${wl-clipboard}/bin/wl-copy
  #       ${_ libnotify} "$(${wl-clipboard}/bin/wl-paste)"
  #     '';
  #   moveWindows = pkgs.writeShellScriptBin "hypeMoveMonitors" ''
  #     #!/bin/sh
  #     function handle {
  #         if [[ ''${1:0:10} == "openwindow" ]]; then
  #             #
  #             # Move YouTube Music to workspace special workspace when opened
  #             #
  #             sleep 2
  #             json_output=$(hyprctl clients -j)
  #             address=''${1:12:7}
  #             title=$(echo "$json_output" | jq '.[] | select(.address == "0x'$address'") | .title')
  #             echo
  #             if [[ $title == "\"Music — Mozilla Firefo\"" ]]; then
  #                 hyprctl dispatch movetoworkspace special:music,address:0x''${1:12:7}
  #             fi
  #         fi
  #     }
  #     socat -t 1000 -U - UNIX-CONNECT:/tmp/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock  | while read line; do handle $line; done
  #   '';
  #   hyprlandWorkspaceMonitorFix = pkgs.writeShellScriptBin "hyprlandWorspaceMonitorFix" ''
  #     #!/bin/sh
  #     function handle {
  #       if [[ ''${1:0:12} == "monitoradded" ]]; then
  #         hyprctl dispatch moveworkspacetomonitor 1 DP-2 && hyprctl dispatch moveworkspacetomonitor 2 DP-2 && hyprctl dispatch moveworkspacetomonitor 3 DP-2 && hyprctl dispatch moveworkspacetomonitor 4 DP-2 && hyprctl dispatch moveworkspacetomonitor 5 DP-2 && hyprctl dispatch moveworkspacetomonitor 6 DP-3 && hyprctl dispatch moveworkspacetomonitor 7 DP-3 && hyprctl dispatch moveworkspacetomonitor 8 DP-3 && hyprctl dispatch moveworkspacetomonitor 9 DP-3 && hyprctl dispatch moveworkspacetomonitor 10 DP-2
  #         hyprctl dispatch workspace 1 && hyprctl dispatch workspace 2 && hyprctl dispatch workspace 3 && hyprctl dispatch workspace 4 && hyprctl dispatch workspace 5 && hyprctl dispatch workspace 6 && hyprctl dispatch workspace 7 && hyprctl dispatch workspace 8 && hyprctl dispatch workspace 9 && hyprctl dispatch workspace 10 && hyprctl dispatch workspace 6 && hyprctl dispatch workspace 1 && $statusbar
  #       fi
  #     }
  #     socat - UNIX-CONNECT:/tmp/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock  | while read line; do handle $line; done
  #   '';
in {
  home.packages = [
    pkgs.socat
    pkgs.gojq
    # hyprlandWorkspaceMonitorFix
    # moveWindows
    # ocrScript
  ];
}
