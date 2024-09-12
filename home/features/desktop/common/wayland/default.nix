{
  pkgs,
  inputs,
  lib,
  ...
}: {
  imports = [
    ./gammastep.nix
    # ./kitty.nix
    # ./mako.nix
    # ./swaylock.nix
    ./waybar
    # ./eww
    # ./eww/eww.nix
    ./rofi.nix
    # ./wofi.nix
    ./gtk.nix
    ./dunst
    ./darkman
    ./swaync.nix
  ];

  home.packages = with pkgs; [
    imv
    clipman
    pulseaudio
    wf-recorder
    wl-clipboard
    waypipe
    grim
    slurp
  ];

  home.sessionVariables = {
    # XDG Specifications

    HYPRCURSOR_THEME = "HyprBibataModernClassicSVG";
    HYPRCURSOR_SIZE = "24";
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_TYPE = "wayland";
    XDG_SESSION_DESKTOP = "Hyprland";
    # QT Variables
    DISABLE_QT5_COMPAT = "0";
    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
    # QT_STYLE_OVERRIDE = "kvantum";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    NIXOS_OZONE_WL = "1";
    # Toolkit Backend Variables
    # SDL_VIDEODRIVER = "wayland";
    _JAVA_AWT_WM_NONREPARENTING = "1";
    CLUTTER_BACKEND = "wayland";
    GDK_BACKEND = "wayland";
    LIBSEAT_BACKEND = "logind";
    MOZ_ENABLE_WAYLAND = "1";
    QT_QPA_PLATFORM = "wayland";
  };
}
