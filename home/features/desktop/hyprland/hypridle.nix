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
      ddcutil
      fish
    ];
  };

  # Create the autoBrightness script
  xdg.configFile."hypr/autoBrightness.sh" = {
    executable = true;
    text = ''
      #!${pkgs.fish}/bin/fish

      set HOUR (date +%H | string trim)

      # Convert hour to number for comparison
      set HOUR_NUM (echo $HOUR | sed 's/^0//')

      # Low brightness between 20:00 and 08:00
      if test $HOUR_NUM -ge 20; or test $HOUR_NUM -lt 8
        ${pkgs.ddcutil}/bin/ddcutil --bus=10 setvcp 10 0
        ${pkgs.ddcutil}/bin/ddcutil --bus=11 setvcp 10 0
      else
        ${pkgs.ddcutil}/bin/ddcutil --bus=10 setvcp 10 100
        ${pkgs.ddcutil}/bin/ddcutil --bus=11 setvcp 10 100
      end
    '';
  };

  xdg.configFile."hypr/hypridle.conf".text = ''
    general {
        lock_cmd = notify-send "lock!"
        unlock_cmd = notify-send "unlock!"
        before_sleep_cmd = notify-send "Zzz"
        after_sleep_cmd = notify-send "Awake!"
        ignore_dbus_inhibit = false
    }

    listener {
        timeout = 300
        on-timeout = hyprctl sleep 1 && hyprctl dispatch dpms off && ${mediaPause}
        on-resume = hyprctl dispatch dpms on && sleep 1 && ${restartXdgPortal} && ${restartWaybar} && ~/.config/hypr/autoBrightness.sh && sleep 1 && ~/.config/hypr/autoBrightness.sh
    }
  '';
}
