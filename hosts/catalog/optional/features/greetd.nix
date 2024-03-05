# {pkgs, ...}: let
#   user = "gogsaan";
#   greetd = "${pkgs.greetd.greetd}/bin/greetd";
#   # sway-kiosk = command: "${pkgs.sway}/bin/sway --config ${pkgs.writeText "kiosk.config" ''
#   #   output * bg #000000 solid_color
#   #   # exec dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY SWAYSOCK
#   #   exec dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY XDG_CURRENT_DESKTOP SWAYSOCK
#   #   exec "${command}; ${pkgs.sway}/bin/swaymsg exit"
#   # ''}";
# in {
#   services.greetd = {
#     enable = true;
#     settings = rec {
#       initial_session = {
#         command = "Hyprland";
#         # command = sway-kiosk "-l -c Hyprland";
#         user = "gogsaan";
#       };
#       default_session = initial_session;
#     };
#   };
# }
{pkgs, ...}: let
  greetd = "${pkgs.greetd.greetd}/bin/greetd";
  tuigreet = "${pkgs.greetd.tuigreet}/bin/tuigreet";
  # # sway-kiosk = command: "${pkgs.sway}/bin/sway --config ${pkgs.writeText "kiosk.config" ''
  # #   output * bg #000000 solid_color
  # #   exec dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY XDG_CURRENT_DESKTOP SWAYSOCK
  # #   exec "${command}; ${pkgs.sway}/bin/swaymsg exit"
  # # ''}";
in {
  services.greetd = {
    enable = true;
    settings = rec {
      initial_session = {
        command = "${tuigreet} --greeting Welcome to GZA-DT --remember --time --cmd Hyprland ";
        user = "gogsaan";
      };
      default_session = initial_session;
    };
  };
}
