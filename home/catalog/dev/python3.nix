{
  lib,
  pkgs,
  ...
}: {
  home = {
    packages = [
      pkgs.python3
    ];
  };
}
