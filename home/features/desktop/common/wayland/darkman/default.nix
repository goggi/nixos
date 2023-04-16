{pkgs, ...}: {
  home.packages = with pkgs; [
    darkman
  ];
}
