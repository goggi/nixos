{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: let
  cursor = "HyprBibataModernClassicSVG";
  cursorPackage = pkgs.bibata-hyprcursor;
in {
  imports = [
    ../common/wayland
    ./scripts.nix
    ./hypridle.nix
    ./hyprpaper.nix
  ];

  home = {
    packages = with pkgs; [
      pngquant
      python39Packages.requests
      tesseract5
      xorg.xprop
      hyprland-per-window-layout
      grimblast
    ];
  };

  home.file.".icons/${cursor}".source = "${cursorPackage}/share/icons/${cursor}";
  xdg.dataFile."icons/${cursor}".source = "${cursorPackage}/share/icons/${cursor}";

  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    # package = pkgs.hyprland;
    systemd = {
      enable = true;
      variables = ["--all"];
      extraCommands = [
        "systemctl --user stop graphical-session.target"
        "systemctl --user start hyprland-session.target"
      ];
    };
    xwayland = {
      enable = true;
    };
    extraConfig = import ./config.nix;
  };
}
