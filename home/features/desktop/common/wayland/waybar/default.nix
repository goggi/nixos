{
  pkgs,
  lib,
  config,
  ...
}: let
  jq = "${pkgs.jq}/bin/jq";

  jsonOutput = name: {
    pre ? "",
    text ? "",
    tooltip ? "",
    alt ? "",
    class ? "",
    percentage ? "",
  }: "${pkgs.writeShellScriptBin "waybar-${name}" ''
    set -euo pipefail
    ${pre}
    ${jq} -cn \
      --arg text "${text}" \
      --arg tooltip "${tooltip}" \
      --arg alt "${alt}" \
      --arg class "${class}" \
      --arg percentage "${percentage}" \
      '{text:$text,tooltip:$tooltip,alt:$alt,class:$class,percentage:$percentage}'
  ''}/bin/waybar-${name}";

  playerctl = "${pkgs.playerctl}/bin/playerctl";
  cut = "${pkgs.coreutils}/bin/cut";
  wc = "${pkgs.coreutils}/bin/wc";

  brightnessctl = pkgs.brightnessctl + "/bin/brightnessctl";
  pamixer = pkgs.pamixer + "/bin/pamixer";
  waybar-wttr = pkgs.stdenv.mkDerivation {
    name = "waybar-wttr";
    buildInputs = [
      (pkgs.python3.withPackages
        (pythonPackages: with pythonPackages; [requests]))
    ];
    unpackPhase = "true";
    installPhase = ''
      mkdir -p $out/bin
      cp ${./scripts/waybar-wttr.py} $out/bin/waybar-wttr
      chmod +x $out/bin/waybar-wttr
    '';
  };
in {
  xdg.configFile."waybar/style.css".text = import ./style.nix;

  programs.waybar = {
    enable = true;
    package = pkgs.waybar;

    settings = {
      secondary = {
        output = "DP-3";
        layer = "top";
        position = "top";
        # mode = "dock";
        exclusive = true;
        passthrough = false;
        fixed-center = true;
        # margin = "100 0 100 0";
        gtk-layer-shell = true;
        height = 34;
        modules-left = [
          "hyprland/workspaces"
        ];

        modules-center = [
        ];

        modules-right = [
          "custom/ip"
          # "custom/weather"
          # "custom/lang"
          "clock"
        ];

        "hyprland/workspaces" = {
          "on-scroll-up" = "hyprctl dispatch workspace r-1";
          "on-scroll-down" = "hyprctl dispatch workspace r+1";
          "all-outputs" = false;
          "format" = "{name}";
          "format-icons" = {
            "active" = "";
            "default" = "";
            "persistent" = "";
          };
          # "persistent_workspaces" = {
          #   "*" = 5;
          # };
        };

        "custom/lang" = {
          "interval" = 10;
          "tooltip" = false;
          "return-type" = "string";
          "format" = "  {}";
          "exec" = "hyprctl -j devices | jq -r '.keyboards[] | select(.name==\"dygma-raise-keyboard\") | .active_keymap'";
        };

        # "custom/logo" = {
        #   tooltip = false;
        #   format = " ";
        # };

        # "custom/todo" = {
        #   tooltip = true;
        #   format = "{}";
        #   interval = 7;
        #   exec = let
        #     todo = pkgs.todo + "/bin/todo";
        #     sed = pkgs.gnused + "/bin/sed";
        #     wc = pkgs.coreutils + "/bin/wc";
        #   in
        #     pkgs.writeShellScript "todo-waybar" ''
        #       #!/bin/sh

        #       total_todo=$(${todo} | ${wc} -l)
        #       todo_raw_done=$(${todo} raw done | ${sed} 's/^/      ◉ /' | ${sed} -z 's/\n/\\n/g')
        #       todo_raw_undone=$(${todo} raw todo | ${sed} 's/^/     ◉ /' | ${sed} -z 's/\n/\\n/g')
        #       done=$(${todo} raw done | ${wc} -l)
        #       undone=$(${todo} raw todo | ${wc} -l)
        #       tooltip=$(${todo})

        #       left="$done/$total_todo"

        #       header="<b>todo</b>\\n\\n"
        #       tooltip=""
        #       if [[ $total_todo -gt 0 ]]; then
        #       	if [[ $undone -gt 0 ]]; then
        #       		export tooltip="$header👷 Today, you need to do:\\n\\n $(echo $todo_raw_undone)\\n\\n✅ You have already done:\\n\\n $(echo $todo_raw_done)"
        #       		export output=" 🗒️ $left"
        #       	else
        #       		export tooltip="$header✅ All done!\\n🥤 Remember to stay hydrated!"
        #       		export output=" 🎉 $left"
        #       	fi
        #       else
        #       	export tooltip=""
        #       	export output=""
        #       fi

        #       printf '{"text": "%s", "tooltip": "%s" }' "$output" "$tooltip"
        #     '';
        #   return-type = "json";
        # };

        "custom/weather" = {
          tooltip = true;
          format = "{}";
          interval = 30;
          exec = "${waybar-wttr}/bin/waybar-wttr";
          return-type = "json";
        };

        # "custom/swallow" = {
        #   tooltip = false;
        #   on-click = let
        #     hyprctl = config.wayland.windowManager.hyprland.package + "/bin/hyprctl";
        #     notify-send = pkgs.libnotify + "/bin/notify-send";
        #     rg = pkgs.ripgrep + "/bin/rg";
        #   in
        #     pkgs.writeShellScript "waybar-swallow" ''
        #       #!/bin/sh
        #       if ${hyprctl} getoption misc:enable_swallow | ${rg}/bin/rg -q "int: 1"; then
        #       	${hyprctl} keyword misc:enable_swallow false >/dev/null &&
        #       		${notify-send} "Hyprland" "Turned off swallowing"
        #       else
        #       	${hyprctl} keyword misc:enable_swallow true >/dev/null &&
        #       		${notify-send} "Hyprland" "Turned on swallowing"
        #       fi
        #     '';
        #   format = "󰊰";
        # };

        "custom/ip" = {
          "format" = "<span foreground='orange'>{} </span>";
          "exec" = "curl ifconfig.co/";
          "return-type" = "string";
          "interval" = 60;
        };

        # "custom/vpn" = {
        #   "format" = "<span foreground='orange'>  </span>";
        #   "exec" = "echo '{\"class\": \"connected\"}'";
        #   "exec-if" = "test -d /proc/sys/net/ipv4/conf/tun0";
        #   "return-type" = "json";
        #   "interval" = 5;
        #   "on-click" = "vpn";
        #   "on-click-right" = "novpn";
        # };

        # "custom/power" = {
        #   tooltip = false;
        #   on-click = "power-menu";
        #   format = "󰤆";
        # };

        tray = {
          spacing = 10;
        };

        clock = {
          tooltip = false;
          format = "󱑎 {:%H:%M}";
        };

        "clock#date" = {
          format = "󰃶 {:%a %d %b}";
          tooltip-format = ''
            <big>{:%Y %B}</big>
            <tt><small>{calendar}</small></tt>'';
        };

        backlight = {
          tooltip = false;
          format = "{icon} {percent}%";
          format-icons = ["󰋙" "󰫃" "󰫄" "󰫅" "󰫆" "󰫇" "󰫈"];
          on-scroll-up = "${brightnessctl} s 1%-";
          on-scroll-down = "${brightnessctl} s +1%";
        };

        battery = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          tooltip-format = "{timeTo}, {capacity}%";
          format-charging = "󰂄 {capacity}%";
          format-plugged = "󰚥 {capacity}%";
          format-alt = "{time} {icon}";
          format-icons = ["󰂃" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
        };

        network = {
          format-wifi = "󰖩 {essid}";
          format-ethernet = "󰈀 {ipaddr}/{cidr}";
          format-alt = "󱛇";
          format-disconnected = "󰖪";
          tooltip-format = ''
            󰅃 {bandwidthUpBytes} 󰅀 {bandwidthDownBytes}
            {ipaddr}/{ifname} via {gwaddr} ({signalStrength}%)'';
        };

        pulseaudio = {
          tooltip = false;
          format = "{icon} {volume}%";
          format-muted = "󰖁";
          format-icons = {default = ["󰕿" "󰖀" "󰕾"];};
          tooltip-format = "{desc}, {volume}%";
          on-click = "${pamixer} -t";
          on-scroll-up = "${pamixer} -d 1";
          on-scroll-down = "${pamixer} -i 1";
        };

        "pulseaudio#microphone" = {
          tooltip = false;
          format = "{format_source}";
          format-source = "󰍬 {volume}%";
          format-source-muted = "󰍭";
          on-click = "${pamixer} --default-source -t";
          on-scroll-up = "${pamixer} --default-source -d 1";
          on-scroll-down = "${pamixer} --default-source -i 1";
        };
      };
      primary = {
        enable = false;
        output = "DP-2";
        layer = "top";
        position = "top";
        # mode = "dock";
        exclusive = true;
        passthrough = false;
        fixed-center = true;
        gtk-layer-shell = true;
        height = 34;
        modules-left = [
          "custom/logo"
          "hyprland/workspaces"
          # "custom/logo"
          # "wlr/workspaces"
          # "custom/swallow"
          # "custom/todo"

          # "battery"
          # "backlight"
          # "pulseaudio#microphone"
        ];

        modules-center = [
          # "custom/vpn"
          # "custom/wifi"
          # "pulseaudio"
          # "custom/notification"
          "custom/currentplayer"
          "network"
        ];

        modules-right = [
          # "tray"
          # "custom/power"
          "custom/weather"
          "temperature"
          "custom/lang"
          "clock#date"
          "clock"
          "tray"
        ];

        "hyprland/workspaces" = {
          "on-scroll-up" = "hyprctl dispatch workspace r-1";
          "on-scroll-down" = "hyprctl dispatch workspace r+1";
          "all-outputs" = false;
          "format" = "{name}";
          "format-icons" = {
            "active" = "";
            "default" = "";
            "persistent" = "";
          };
          # "persistent_workspaces" = {
          #   "*" = 5;
          # };
        };

        "custom/currentplayer" = {
          exec-if = "${playerctl} status";
          # exec = ''${playerctl} metadata --format '{"text": "{{artist}} - {{title}}", "alt": "{{status}}", "tooltip": "{{title}} ({{artist}} - {{album}})"}' '';
          exec = ''${playerctl} metadata --format '{"text": "{{title}}", "alt": "{{status}}", "tooltip": "{{title}} ({{artist}} - {{album}})"}' '';
          return-type = "json";
          interval = 2;
          max-length = 60;
          format = "{icon} {}";
          format-icons = {
            "Playing" = "󰐊";
            "Paused" = "󰏤 ";
            "Stopped" = "󰓛";
          };
          # on-click = "${playerctl} play-pause";
          on-click = "hyprctl dispatch togglespecialworkspace music";
        };

        # "custom/wifi" = {
        #   "tooltip" = false;
        #   "format" = "<span foreground='orange'>TUI </span>";
        #   "exec" = "echo '{\"class\": \"connected\"}'";
        #   "exec-if" = "nmcli radio wifi | grep -q enabled || return 1";
        #   "return-type" = "json";
        #   "interval" = 10;
        #   "on-click" = "nmcli radio wifi off";
        # };

        "custom/ip" = {
          "format" = "<span foreground='orange'>{} </span>";
          "exec" = "curl ifconfig.co/";
          "return-type" = "string";
          "interval" = 60;
        };

        # "custom/vpn" = {
        #   "format" = "<span foreground='orange'>VPN  </span>";
        #   "exec" = "echo '{\"class\": \"connected\"}'";
        #   "exec-if" = "test -d /proc/sys/net/ipv4/conf/tun0";
        #   "return-type" = "json";
        #   "interval" = 10;
        #   "on-click" = "vpn";
        #   "on-click-right" = "novpn";
        # };

        "custom/lang" = {
          "interval" = 10;
          "tooltip" = false;
          "return-type" = "string";
          "format" = "  {}";
          "exec" = "hyprctl -j devices | jq -r '.keyboards[] | select(.name==\"dygma-raise-keyboard\") | .active_keymap'";
        };

        "temperature" = {
          hwmon-path = "/sys/class/hwmon/hwmon1/temp3_input";
          critical-threshold = 90;
          interval = 5;
          format = "{icon} {temperatureC} °C";
          tooltip = false;
          on-click = "swaymsg exec \"\\$term_float watch sensors\"";
        };

        "wlr/workspaces" = {
          on-click = "activate";
          format = "{name}";
          # format = "{icon}";
          # format-icons = {
          #   urgent = "";
          #   active = "";
          #   default = "";
          #   sort-by-number = true;
          # };
          all-outputs = false;
          disable-scroll = true;
          active-only = false;
          sort-by-name = false;
          sort-by-number = true;
        };

        "custom/logo" = {
          tooltip = false;
          format = " ";
        };

        # "custom/todo" = {
        #   tooltip = true;
        #   format = "{}";
        #   interval = 7;
        #   exec = let
        #     todo = pkgs.todo + "/bin/todo";
        #     sed = pkgs.gnused + "/bin/sed";
        #     wc = pkgs.coreutils + "/bin/wc";
        #   in
        #     pkgs.writeShellScript "todo-waybar" ''
        #       #!/bin/sh

        #       total_todo=$(${todo} | ${wc} -l)
        #       todo_raw_done=$(${todo} raw done | ${sed} 's/^/      ◉ /' | ${sed} -z 's/\n/\\n/g')
        #       todo_raw_undone=$(${todo} raw todo | ${sed} 's/^/     ◉ /' | ${sed} -z 's/\n/\\n/g')
        #       done=$(${todo} raw done | ${wc} -l)
        #       undone=$(${todo} raw todo | ${wc} -l)
        #       tooltip=$(${todo})

        #       left="$done/$total_todo"

        #       header="<b>todo</b>\\n\\n"
        #       tooltip=""
        #       if [[ $total_todo -gt 0 ]]; then
        #       	if [[ $undone -gt 0 ]]; then
        #       		export tooltip="$header👷 Today, you need to do:\\n\\n $(echo $todo_raw_undone)\\n\\n✅ You have already done:\\n\\n $(echo $todo_raw_done)"
        #       		export output=" 🗒️ $left"
        #       	else
        #       		export tooltip="$header✅ All done!\\n🥤 Remember to stay hydrated!"
        #       		export output=" 🎉 $left"
        #       	fi
        #       else
        #       	export tooltip=""
        #       	export output=""
        #       fi

        #       printf '{"text": "%s", "tooltip": "%s" }' "$output" "$tooltip"
        #     '';
        #   return-type = "json";
        # };

        "custom/weather" = {
          tooltip = true;
          format = "{}";
          interval = 600;
          exec = "${waybar-wttr}/bin/waybar-wttr";
          return-type = "json";
        };

        "custom/notification" = {
          "tooltip" = false;
          "format" = "{icon}";
          "format-icons" = {
            "notification" = "<span foreground='#f2cdcd'></span>";
            # "notification" = "<span foreground='red'><sup></sup></span>";
            # "none" = "";
            # "dnd-notification" = "<span foreground='red'><sup></sup></span>";
            # "dnd-none" = "";
            # "inhibited-notification" = "<span foreground='red'><sup></sup></span>";
            # "inhibited-none" = "";
            # "dnd-inhibited-notification" = "<span foreground='red'><sup></sup></span>";
            # "dnd-inhibited-none" = "";
          };
          "return-type" = "json";
          "exec-if" = "which swaync-client";
          "exec" = "swaync-client -swb";
          "on-click" = "swaync-client -t -sw";
          "on-click-right" = "swaync-client -d -sw";
          "escape" = true;
        };

        # "custom/swallow" = {
        #   tooltip = false;
        #   on-click = let
        #     hyprctl = config.wayland.windowManager.hyprland.package + "/bin/hyprctl";
        #     notify-send = pkgs.libnotify + "/bin/notify-send";
        #     rg = pkgs.ripgrep + "/bin/rg";
        #   in
        #     pkgs.writeShellScript "waybar-swallow" ''
        #       #!/bin/sh
        #       if ${hyprctl} getoption misc:enable_swallow | ${rg}/bin/rg -q "int: 1"; then
        #       	${hyprctl} keyword misc:enable_swallow false >/dev/null &&
        #       		${notify-send} "Hyprland" "Turned off swallowing"
        #       else
        #       	${hyprctl} keyword misc:enable_swallow true >/dev/null &&
        #       		${notify-send} "Hyprland" "Turned on swallowing"
        #       fi
        #     '';
        #   format = "󰊰";
        # };

        "custom/power" = {
          tooltip = false;
          on-click = "power-menu";
          format = "󰤆";
        };

        tray = {
          spacing = 10;
        };

        clock = {
          tooltip = false;
          format = "󱑎 {:%H:%M}";
        };

        "clock#date" = {
          format = "󰃶 {:%d %b}";
          tooltip-format = ''
            <big>{:%Y %B}</big>
            <tt><small>{calendar}</small></tt>'';
        };

        backlight = {
          tooltip = false;
          format = "{icon} {percent}%";
          format-icons = ["󰋙" "󰫃" "󰫄" "󰫅" "󰫆" "󰫇" "󰫈"];
          on-scroll-up = "${brightnessctl} s 1%-";
          on-scroll-down = "${brightnessctl} s +1%";
        };

        battery = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          tooltip-format = "{timeTo}, {capacity}%";
          format-charging = "󰂄 {capacity}%";
          format-plugged = "󰚥 {capacity}%";
          format-alt = "{time} {icon}";
          format-icons = ["󰂃" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
        };

        network = {
          format-wifi = "󰖩 {essid}";
          format-ethernet = "";
          format-alt = "";
          format-disconnected = "";
          tooltip-format = ''
            󰅃 {bandwidthUpBytes} 󰅀 {bandwidthDownBytes}
            {ipaddr}/{ifname} via {gwaddr} ({signalStrength}%)'';
        };

        pulseaudio = {
          tooltip = false;
          format = "{icon} {volume}%";
          format-muted = "󰖁";
          format-icons = {default = ["󰕿" "󰖀" "󰕾"];};
          tooltip-format = "{desc}, {volume}%";
          on-click = "${pamixer} -t";
          on-scroll-up = "pactl set-default-sink 50";
          on-scroll-down = "pactl set-default-sink 13118";
        };

        "pulseaudio#microphone" = {
          tooltip = false;
          format = "{format_source}";
          format-source = "󰍬 {volume}%";
          format-source-muted = "󰍭";
          on-click = "${pamixer} --default-source -t";
          on-scroll-up = "${pamixer} --default-source -d 1";
          on-scroll-down = "${pamixer} --default-source -i 1";
        };
      };
    };
  };
}
