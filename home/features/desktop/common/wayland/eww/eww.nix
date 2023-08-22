{
  inputs,
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    inputs.gross.packages.${pkgs.system}.gross
    config.wayland.windowManager.hyprland.package
    bash
    blueberry
    bluez
    brillo
    coreutils
    dbus
    findutils
    gawk
    gnome.gnome-control-center
    gnused
    imagemagick
    jaq
    jc
    libnotify
    networkmanager
    pavucontrol
    playerctl
    procps
    pulseaudio
    ripgrep
    socat
    udev
    upower
    util-linux
    wget
    wireplumber
    wlogout
  ];

  imports = [inputs.fufexan.homeManagerModules.eww-hyprland];

  programs.eww-hyprland = {
    enable = true;

    # default package
    package = pkgs.eww-wayland;

    # if you want to change colors
    # colors = builtins.readFile ./latte.scss;

    # set to true to reload on change
    autoReload = false;
  };
}
