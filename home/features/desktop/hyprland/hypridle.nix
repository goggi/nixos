{pkgs, ...}: let
  hyprctl = "hyprctl";
  resetSpecialWorkspace = "hyprctl dispatch workspace 1 && hyprctl dispatch togglespecialworkspace chatgpt && hyprctl dispatch togglespecialworkspace music && hyprctl dispatch togglespecialworkspace kitty && hyprctl dispatch togglespecialworkspace obsidian && hyprctl dispatch togglespecialworkspace obsidian && sleep 0.1
 workspace 7 &&  hyprctl dispatch workspace 1 &&  hyprctl dispatch workspace 7 &&  hyprctl dispatch workspace 1";
  mediaPause = "hyprctl dispatch exec \"playerctl pause\"";
  restartWaybar = "hyprctl dispatch exec \"pkill waybar && waybar &\"";
  restartXdgPortal = "hyprctl dispatch exec \"systemctl --user restart xdg-desktop-portal-hyprland\"";
in {
  home = {
    packages = with pkgs; [
      hypridle
    ];
  };

  xdg.configFile."hypr/hypridle.conf".text = ''
    general {
        lock_cmd = notify-send "lock!"          # dbus/sysd lock command (loginctl lock-session)
        unlock_cmd = notify-send "unlock!"      # same as above, but unlock
        before_sleep_cmd = notify-send "Zzz"    # command ran before sleep
        after_sleep_cmd = notify-send "Awake!"  # command ran after sleep
        ignore_dbus_inhibit = false             # whether to ignore dbus-sent idle-inhibit requests (used by e.g. firefox or steam)
    }

    listener {
        timeout = 10
        on-timeout = hyprctl dispatch dpms off && ${mediaPause}
        on-resume = hyprctl dispatch dpms on && sleep 1 && ${restartXdgPortal} && ${resetSpecialWorkspace} && ${restartWaybar}
    }
  '';
}
