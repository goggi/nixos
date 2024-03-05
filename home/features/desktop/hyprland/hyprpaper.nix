{pkgs, ...}: let
in {
  home = {
    packages = with pkgs; [
      hyprpaper
    ];
  };

  xdg.configFile."hypr/hyprpaper.conf".text = ''
    preload = /home/gogsaan/Pictures/wallpapers/nixos/51202150962_e6317cf68f_o.jpg
    wallpaper = DP-2,/home/gogsaan/Pictures/wallpapers/nixos/51202150962_e6317cf68f_o.jpg
    wallpaper = DP-3,/home/gogsaan/Pictures/wallpapers/nixos/51202150962_e6317cf68f_o.jpg
    splash = false
    # wallpaper = DP-1,/home/me/amongus.png
  '';
}
