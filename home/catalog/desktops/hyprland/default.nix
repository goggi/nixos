{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: let
in {
  imports = [
    inputs.hyprland.homeManagerModules.default
    ../common/wayland
    ../common
    ./scripts.nix
  ];

  home = {
    packages = with pkgs; [
      pngquant
      python39Packages.requests
      tesseract5
      xorg.xprop
      inputs.hyprland-contrib.packages.${pkgs.system}.grimblast
    ];
  };

  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.default.override {};
    systemdIntegration = true;
    extraConfig = import ./config.nix;
  };
}
