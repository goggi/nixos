{
  lib,
  pkgs,
  ...
}: {
  home = {
    packages = [
      # pkgs.nodejs
      pkgs.nodejs_22
      pkgs.yarn
      pkgs.nodePackages.pnpm
      pkgs.devspace
      # pkgs.nodePackages.cdktf-cli

      # pkgs.okteto
      # pkgs.postgresql
    ];
  };
}
