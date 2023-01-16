{
  lib,
  pkgs,
  ...
}: {
  home = {
    packages = [
      pkgs.nodejs
      pkgs.yarn
      pkgs.nodePackages.pnpm
    ];
  };
}
