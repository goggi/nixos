{
  lib,
  pkgs,
  ...
}: {
  home = {
    packages = [
      # pkgs.nodejs
      pkgs.nodejs-18_x
      pkgs.yarn
      pkgs.nodePackages.pnpm
      pkgs.deno
      # pkgs.okteto
      # pkgs.postgresql
    ];
  };
}
