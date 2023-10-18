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
      ];

      packageOverrides = super: {
        looking-glass-client = pkgs.callPackage ./looking {};
        vscode = pkgs.callPackage ./vscode/vscode.nix {};
        starsector = pkgs.callPackage ./starsector {};
        devops = pkgs.devops ./devops {};
        # libclang-pip = pkgs.callPackage ./libclang/default.nix {};
        # xwaylandvideobridge = pkgs.callPackage ./xwaylandbridge/default.nix {};
        # webcord = pkgs.callPackage ./webcord/default.nix {};
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
      ++ (importNixFiles ./overlays);
  };
in
  pkgs
