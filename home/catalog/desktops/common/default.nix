{pkgs, ...}: {
  imports = [
    # ./gammastep.nix
  ];

  home.packages = with pkgs; [
    playerctl
  ];
}
