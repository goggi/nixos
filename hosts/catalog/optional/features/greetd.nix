# {pkgs, ...}: let
#   user = "gogsaan";
#   greetd = "${pkgs.greetd.greetd}/bin/greetd";
# in {
#   services.greetd = {
#     enable = true;
#     settings = rec {
#       initial_session = {
#         command = "Hyprland";
#         user = "gogsaan";
#       };
#       default_session = initial_session;
#     };
#   };
# }
{pkgs, ...}: let
  user = "gogsaan";
  greetd = "${pkgs.greetd.greetd}/bin/greetd";
  gtkgreet = "${pkgs.greetd.gtkgreet}/bin/gtkgreet";
  sway-kiosk = command: "${pkgs.sway}/bin/sway --config ${pkgs.writeText "kiosk.config" ''
    output * bg #000000 solid_color
    # exec dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY SWAYSOCK
    exec dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY XDG_CURRENT_DESKTOP SWAYSOCK
    exec "${command}; ${pkgs.sway}/bin/swaymsg exit"
  ''}";
in {
  services.greetd = {
    enable = true;
    settings = rec {
      # initial_session = {
      #   command = "Hyprland";
      #   user = "gogsaan";
      # };
      # default_session = initial_session;
      initial_session = {
        command = sway-kiosk "${gtkgreet} -l -c 'Hyprland'";
        user = "gogsaan";
      };
      default_session = initial_session;
    };
    settings = {
      # default_session = {
      #   command = sway-kiosk "${gtkgreet} -l -c '$SHELL -l'";
      #   inherit user;
      # };
      # initial_session = {
      #   command = "$SHELL -l";
      #   inherit user;
      # };
    };
    # xserver.displayManager.sessionPackages = [inputs.hyprland.packages.${pkgs.system}.default];
  };
}
