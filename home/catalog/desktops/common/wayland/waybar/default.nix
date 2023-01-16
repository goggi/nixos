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

  brightnessctl = pkgs.brightnessctl + "/bin/brightnessctl";
  pamixer = pkgs.pamixer + "/bin/pamixer";
  waybar-wttr = pkgs.stdenv.mkDerivation {
    name = "waybar-wttr";
    buildInputs = [
      (pkgs.python39.withPackages
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
    # systemd.enable = true;
    # package = pkgs.waybar.overrideAttrs (oldAttrs: {
    #   mesonFlags = oldAttrs.mesonFlags ++ ["-Dexperimental=true"];
    #   patchPhase = ''
    #     substituteInPlace src/modules/wlr/workspace_manager.cpp --replace "zext_workspace_handle_v1_activate(workspace_handle_);" "const std::string command = \"${config.wayland.windowManager.hyprland.package}/bin/hyprctl dispatch workspace \" + name_; system(command.c_str());"
    #   '';
    # });

    package = pkgs.waybar.overrideAttrs (oa: {
      mesonFlags = (oa.mesonFlags or []) ++ ["-Dexperimental=true"];
    });

    settings = {
      secondary = {
        output = "DP-3";
        layer = "top";
        position = "top";
        # mode = "dock";
        exclusive = true;
        passthrough = false;
        fixed-center = true;
        gtk-layer-shell = true;
        height = 34;
        modules-left = [
          "wlr/workspaces"
        ];

        modules-center = [
          "custom/ip"
          "custom/vpn"
          "custom/gpg-agent"
        ];

        modules-right = [
        ];

        "custom/gpg-agent" = {
          interval = 2;
          return-type = "json";
          exec = let
            keyring = import ../../../../features/keyring.nix {inherit pkgs;};
          in
            jsonOutput "gpg-agent" {
              pre = ''status=$(${keyring.isUnlocked} && echo "unlocked" || echo "locked")'';
              alt = "$status";
              tooltip = "GPG is $status";
            };
          format = "{icon}";
          format-icons = {
            "locked" = "";
            "unlocked" = "";
          };
          on-click = "";
        };

        "wlr/workspaces" = {
          on-click = "activate";
          format = "{name}";
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

        "custom/todo" = {
          tooltip = true;
          format = "{}";
          interval = 7;
          exec = let
            todo = pkgs.todo + "/bin/todo";
            sed = pkgs.gnused + "/bin/sed";
            wc = pkgs.coreutils + "/bin/wc";
          in
            pkgs.writeShellScript "todo-waybar" ''
              #!/bin/sh

              total_todo=$(${todo} | ${wc} -l)
              todo_raw_done=$(${todo} raw done | ${sed} 's/^/      ◉ /' | ${sed} -z 's/\n/\\n/g')
              todo_raw_undone=$(${todo} raw todo | ${sed} 's/^/     ◉ /' | ${sed} -z 's/\n/\\n/g')
              done=$(${todo} raw done | ${wc} -l)
              undone=$(${todo} raw todo | ${wc} -l)
              tooltip=$(${todo})

              left="$done/$total_todo"

              header="<b>todo</b>\\n\\n"
              tooltip=""
              if [[ $total_todo -gt 0 ]]; then
              	if [[ $undone -gt 0 ]]; then
              		export tooltip="$header👷 Today, you need to do:\\n\\n $(echo $todo_raw_undone)\\n\\n✅ You have already done:\\n\\n $(echo $todo_raw_done)"
              		export output=" 🗒️ $left"
              	else
              		export tooltip="$header✅ All done!\\n🥤 Remember to stay hydrated!"
              		export output=" 🎉 $left"
              	fi
              else
              	export tooltip=""
              	export output=""
              fi

              printf '{"text": "%s", "tooltip": "%s" }' "$output" "$tooltip"
            '';
          return-type = "json";
        };

        "custom/weather" = {
          tooltip = true;
          format = "{}";
          interval = 30;
          exec = "${waybar-wttr}/bin/waybar-wttr";
          return-type = "json";
        };

        "custom/swallow" = {
          tooltip = false;
          on-click = let
            hyprctl = config.wayland.windowManager.hyprland.package + "/bin/hyprctl";
            notify-send = pkgs.libnotify + "/bin/notify-send";
            rg = pkgs.ripgrep + "/bin/rg";
          in
            pkgs.writeShellScript "waybar-swallow" ''
              #!/bin/sh
              if ${hyprctl} getoption misc:enable_swallow | ${rg}/bin/rg -q "int: 1"; then
              	${hyprctl} keyword misc:enable_swallow false >/dev/null &&
              		${notify-send} "Hyprland" "Turned off swallowing"
              else
              	${hyprctl} keyword misc:enable_swallow true >/dev/null &&
              		${notify-send} "Hyprland" "Turned on swallowing"
              fi
            '';
          format = "󰊰";
        };

        "custom/ip" = {
          "format" = "<span foreground='orange'>{} </span>";
          "exec" = "curl ifconfig.co/";
          "return-type" = "string";
          "interval" = 60;
        };

        "custom/vpn" = {
          "format" = "<span foreground='orange'>  </span>";
          "exec" = "echo '{\"class\": \"connected\"}'";
          "exec-if" = "test -d /proc/sys/net/ipv4/conf/tun0";
          "return-type" = "json";
          "interval" = 5;
          "on-click" = "vpn";
          "on-click-right" = "novpn";
        };

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
          "wlr/workspaces"
          "custom/swallow"
          "custom/todo"
        ];

        modules-center = [
          "custom/vpn"
        ];

        modules-right = [
          # "custom/weather"
          "custom/weather"
          "temperature"
          "battery"
          "backlight"
          # "pulseaudio#microphone"
          # "network"
          "custom/lang"
          "pulseaudio"

          "clock#date"
          "clock"
          # "custom/power"

          "tray"
        ];

        "custom/ip" = {
          "format" = "<span foreground='orange'>{} </span>";
          "exec" = "curl ifconfig.co/";
          "return-type" = "string";
          "interval" = 60;
        };

        "custom/vpn" = {
          "format" = "<span foreground='orange'>  </span>";
          "exec" = "echo '{\"class\": \"connected\"}'";
          "exec-if" = "test -d /proc/sys/net/ipv4/conf/tun0";
          "return-type" = "json";
          "interval" = 5;
          "on-click" = "vpn";
          "on-click-right" = "novpn";
        };

        "custom/lang" = {
          "interval" = 5;
          "tooltip" = false;
          "return-type" = "string";
          "format" = " {}";
          "exec" = "hyprctl -j devices | jq -r '.keyboards[] | select(.name==\"dygma-raise-keyboard\") | .active_keymap'";
        };

        "temperature" = {
          hwmon-path = "/sys/class/hwmon/hwmon1/temp3_input";
          critical-threshold = 90;
          interval = 5;
          format = "{icon} {temperatureC}°C";
          # format-icons = [
          #     "",
          #     "",
          #     ""
          # ];
          tooltip = false;
          on-click = "swaymsg exec \"\\$term_float watch sensors\"";
        };

        "wlr/workspaces" = {
          on-click = "activate";
          format = "{name}";
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

        "custom/todo" = {
          tooltip = true;
          format = "{}";
          interval = 7;
          exec = let
            todo = pkgs.todo + "/bin/todo";
            sed = pkgs.gnused + "/bin/sed";
            wc = pkgs.coreutils + "/bin/wc";
          in
            pkgs.writeShellScript "todo-waybar" ''
              #!/bin/sh

              total_todo=$(${todo} | ${wc} -l)
              todo_raw_done=$(${todo} raw done | ${sed} 's/^/      ◉ /' | ${sed} -z 's/\n/\\n/g')
              todo_raw_undone=$(${todo} raw todo | ${sed} 's/^/     ◉ /' | ${sed} -z 's/\n/\\n/g')
              done=$(${todo} raw done | ${wc} -l)
              undone=$(${todo} raw todo | ${wc} -l)
              tooltip=$(${todo})

              left="$done/$total_todo"

              header="<b>todo</b>\\n\\n"
              tooltip=""
              if [[ $total_todo -gt 0 ]]; then
              	if [[ $undone -gt 0 ]]; then
              		export tooltip="$header👷 Today, you need to do:\\n\\n $(echo $todo_raw_undone)\\n\\n✅ You have already done:\\n\\n $(echo $todo_raw_done)"
              		export output=" 🗒️ $left"
              	else
              		export tooltip="$header✅ All done!\\n🥤 Remember to stay hydrated!"
              		export output=" 🎉 $left"
              	fi
              else
              	export tooltip=""
              	export output=""
              fi

              printf '{"text": "%s", "tooltip": "%s" }' "$output" "$tooltip"
            '';
          return-type = "json";
        };

        "custom/weather" = {
          tooltip = true;
          format = "{}";
          interval = 600;
          exec = "${waybar-wttr}/bin/waybar-wttr";
          return-type = "json";
        };

        "custom/swallow" = {
          tooltip = false;
          on-click = let
            hyprctl = config.wayland.windowManager.hyprland.package + "/bin/hyprctl";
            notify-send = pkgs.libnotify + "/bin/notify-send";
            rg = pkgs.ripgrep + "/bin/rg";
          in
            pkgs.writeShellScript "waybar-swallow" ''
              #!/bin/sh
              if ${hyprctl} getoption misc:enable_swallow | ${rg}/bin/rg -q "int: 1"; then
              	${hyprctl} keyword misc:enable_swallow false >/dev/null &&
              		${notify-send} "Hyprland" "Turned off swallowing"
              else
              	${hyprctl} keyword misc:enable_swallow true >/dev/null &&
              		${notify-send} "Hyprland" "Turned on swallowing"
              fi
            '';
          format = "󰊰";
        };

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
    };
  };
}
