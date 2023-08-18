{
  inputs,
  system,
  ...
}: let
  filterNixFiles = k: v: v == "regular" && pkgs.lib.hasSuffix ".nix" k;
  importNixFiles = path: (builtins.map (import path) (pkgs.lib.filterAttrs filterNixFiles (builtins.readDir path)));

  pkgs = import inputs.nixpkgs {
    inherit system;
    config = {
      allowBroken = true;
      allowInsecure = true;
      allowUnfree = true;
      tarball-ttl = 0;
      permittedInsecurePackages = [
        # "electron-21.4.0"
        "nodejs-16.20.0"
        "nodejs-16.20.1"
        "nodejs-16.20.2"
      ];

      packageOverrides = super: {
        looking-glass-client = pkgs.callPackage ./looking {};
        vscode = pkgs.callPackage ./vscode/vscode.nix {};
      };
    };
    overlays = with inputs; [
      (
        final: _: let
          inherit (final) system;
        in {
          sf-mono-liga-src = sf-mono-liga;
        }
      )
      nixpkgs-wayland.overlay
    ];
  };
in
  pkgs
