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

  nixpkgsUnstableSmall = import inputs.nixpkgsUnstableSmall {
    inherit system;
    config = {
      allowUnfree = true;
    };
  };

  nixpkgsUnstable = import inputs.nixpkgsUnstable {
    inherit system;
    config = {
      allowUnfree = true;
    };
  };

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
        "electron-27.3.11"
      ];

      packageOverrides = super: {
        zen-browser = inputs.zen-browser.packages.${system}.default;
        vivaldi = nixpkgsUnstableSmall.vivaldi;
        vivaldi-ffmpeg-codecs = nixpkgsUnstableSmall.vivaldi-ffmpeg-codecs;
        vscode = nixpkgsUnstableSmall.vscode;
        vencord = nixpkgsUnstableSmall.vencord;
        obsidian = nixpkgsUnstable.obsidian;
        navicat = pkgs.callPackage ./active/navicat {};
        bibata-hyprcursor = pkgs.callPackage ./active/bibata {};
        archi = pkgs.callPackage ./active/archi {};
        cursor = pkgs.callPackage ./active/cursor {};
        bazecor = pkgs.callPackage ./active/bazecor {};
        starsector = pkgs.callPackage ./active/starsector {};
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
