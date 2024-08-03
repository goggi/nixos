{
  inputs,
  system,
  lib,
  ...
}: let
  inherit (builtins) mapAttrs;

  pkgsUnstable = import inputs.nixpkgs-unstable {
    inherit system;

    config = {
      allowBroken = true;
      allowInsecure = true;
      allowUnfree = true;
      tarball-ttl = 0;
      permittedInsecurePackages = [
        "nodejs-16.20.0"
        "nodejs-16.20.1"
        "nodejs-16.20.2"
        "electron-25.9.0"
        "electron-24.8.6"
        "freeimage-unstable-2021-11-01"
        "electron-27.3.11"
      ];
    };
  };
in
  pkgsUnstable
