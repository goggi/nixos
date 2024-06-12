{
  lib,
  pkgs,
  ...
}: {
  home = {
    packages = [
      pkgs.gleam
    ];
  };
}
