{
  lib,
  pkgs,
  ...
}: {
  home = {
    packages = [
      # pkgs.nodejs
      pkgs.nodejs-16_x
      pkgs.yarn
      pkgs.nodePackages.pnpm
    ];
  };
}
