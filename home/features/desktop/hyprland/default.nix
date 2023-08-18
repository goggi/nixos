{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: let
  flake-compat = builtins.fetchTarball {
    url = "https://github.com/edolstra/flake-compat/archive/master.tar.gz";
    sha256 = "sha256:1prd9b1xx8c0sfwnyzkspplh30m613j42l1k789s521f4kv4c2z2";
  };
  hyprland =
    (import flake-compat {
      src = builtins.fetchTarball {
        url = "https://github.com/hyprwm/Hyprland/archive/master.tar.gz";
        sha256 = "sha256:086863p2nl3id5agvyhh7k5yx7xka95djw3gby3pax4697dhbqgc";
      };
    })
    .defaultNix;
in {
  imports = [
    hyprland.homeManagerModules.default
    ../common/wayland
    ./scripts.nix
  ];

  home = {
    packages = with pkgs; [
      pngquant
      python39Packages.requests
      tesseract5
      xorg.xprop
      inputs.hyprland-contrib.packages.${pkgs.system}.grimblast
      swayidle
    ];
  };

  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.default.override {};
    # package = pkgs.hyprland;
    systemdIntegration = true;
    xwayland = {
      enable = true;
      hidpi = true;
    };
    extraConfig = import ./config.nix;
  };
}
