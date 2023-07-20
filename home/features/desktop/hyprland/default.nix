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
        sha256 = "sha256:13b37yf36zslap8qd741qh4hhwffxvfb95mq7abwspg6slag2m6c";
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
      hidpi = false;
    };
    extraConfig = import ./config.nix;
  };
}
