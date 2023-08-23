{
  inputs,
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    config.wayland.windowManager.hyprland.package
    bash
    blueberry
    bluez
    coreutils
    dbus
    findutils
    gawk
    gnome.gnome-control-center
    gnused
    gojq
    imagemagick
    jaq
    jc
    light
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
}
## Add to flake.nix wayland file
# eww = {
#   url = "github:ralismark/eww/tray-3";
#   inputs.nixpkgs.follows = "nixpkgs";
#   inputs.rust-overlay.follows = "rust-overlay";
# };
#  Fufexan
# fufexan = {
#   url = "github:fufexan/dotfiles";
#   inputs.nixpkgs.follows = "nixpkgs";
# };
# gross = {
#   url = "github:fufexan/gross";
#   inputs.nixpkgs.follows = "nixpkgs";
#   inputs.flake-parts.follows = "flake-parts";
# };
# rust-overlay = {
#   url = "github:oxalica/rust-overlay";
#   inputs.nixpkgs.follows = "nixpkgs";
#   inputs.flake-utils.follows = "fu";
# };
## Add to default.nix wayland file
# programs.eww-hyprland = {
#   enable = true;
#   # autoReload = true;
#   # temp fix until https://github.com/NixOS/nixpkgs/pull/249515 lands. after that,
#   # eww's nixpkgs has to be updated
#   package = inputs.eww.packages.${pkgs.system}.eww-wayland.overrideAttrs (old: {
#     nativeBuildInputs = old.nativeBuildInputs ++ [pkgs.wrapGAppsHook];
#     buildInputs = lib.lists.remove pkgs.gdk-pixbuf (old.buildInputs ++ [pkgs.librsvg]);
#   });
# };

