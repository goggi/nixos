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
# Install PIP 1.  nix-env -qaP '.*pip.*' 2. nix-env -i python3.10-pip-22.2.2

