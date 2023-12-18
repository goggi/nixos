{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: let
  flake-compat = builtins.fetchTarball {
    url = "https://github.com/edolstra/flake-compat/archive/master.tar.gz";
    sha256 = "sha256:0m9grvfsbwmvgwaxvdzv6cmyvjnlww004gfxjvcl806ndqaxzy4j";
  };
  hyprland =
    (import flake-compat {
      src = builtins.fetchTarball {
        url = "https://github.com/hyprwm/Hyprland/archive/master.tar.gz";
        sha256 = "sha256:0miihb72b4mk02lrwywbgf09i7lhzjvbk2izjc2ipgimcf52g0fc";
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
    };
    extraConfig = import ./config.nix;
  };
}
