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
    ./swayidle.nix
    ./swaylock.nix
    ./waybar
    ./eww
    ./rofi.nix
    # ./wofi.nix
    ./gtk.nix
    ./dunst
    ./darkman
    ./swaync.nix
  ];

  home.packages = with pkgs; [
    imv
    # lyrics
    # mimeo
    # primary-xwayland
    # wl-mirror
    # wl-mirror-pick
    # ydotool
    clipman
    pulseaudio
    wf-recorder
    wl-clipboard
    waypipe
    grim
    slurp
    swaybg
  ];

  services.gammastep = {
    enable = true;
    provider = "geoclue2";
  };

  home.sessionVariables = {
    # XDG Specifications
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_TYPE = "wayland";
    XDG_SESSION_DESKTOP = "Hyprland";
    # XCURSOR_SIZE = "24";
    # GDK_SCALE = "2";
    # QT Variables
    DISABLE_QT5_COMPAT = "0";
    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
    # QT_STYLE_OVERRIDE = "kvantum";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    NIXOS_OZONE_WL = "1";
    # Toolkit Backend Variables
    SDL_VIDEODRIVER = "wayland";
    _JAVA_AWT_WM_NONREPARENTING = "1";
    CLUTTER_BACKEND = "wayland";
    GDK_BACKEND = "wayland";
    LIBSEAT_BACKEND = "logind";
    MOZ_ENABLE_WAYLAND = "1";
    QT_QPA_PLATFORM = "wayland";
  };

  # systemd.user.services.swaybg = let
  #   wallpaper = builtins.fetchurl rec {
  #     name = "wallpaper-${sha256}.png";
  #     url = "https://raw.githubusercontent.com/rxyhn/wallpapers/main/catppuccin/cat_leaves.png";
  #     sha256 = "1894y61nx3p970qzxmqjvslaalbl2skj5sgzvk38xd4qmlmi9s4i";
  #   };
  # in {
  #   Unit = {
  #     Description = "Wayland wallpaper daemon";
  #     PartOf = ["graphical-session.target"];
  #     After = ["graphical-session.target"];
  #   };
  #   Service = {
  #     ExecStart = "${pkgs.swaybg}/bin/swaybg --mode fill --image ${wallpaper}";
  #     Restart = "on-failure";
  #   };

  #   Install.WantedBy = ["graphical-session.target"];
  # };
}
