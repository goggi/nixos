{
  inputs,
  system,
  lib,
  ...
}: let
  inherit (builtins) mapAttrs;

  filterNixFiles = k: v: v == "regular" && lib.hasSuffix ".nix" k;
  importNixFiles = path:
    (lib.lists.forEach (lib.mapAttrsToList (name: _: path + ("/" + name))
        (lib.filterAttrs filterNixFiles (builtins.readDir path))))
    import;

  pkgs = import inputs.nixpkgs {
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
      ];

      packageOverrides = super: {
        thorium = pkgs.callPackage ./active/thorium {};
        floorp = pkgs.callPackage ./active/floorp {};
        waybar = pkgs.callPackage ./active/waybar {};
        # obsidian = pkgs.callPackage ./active/obsidian {};
      };
    };

    overlays = with inputs;
      [
        (
          final: _: let
            inherit (final) system;
          in {
            sf-mono-liga-src = sf-mono-liga;
          }
        )
      ]
      ++ (importNixFiles ./.overlays);
  };
in
  pkgs
