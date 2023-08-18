{
  inputs,
  system,
  ...
}: let
  myOverlay = import ./overlays/derivations.nix;
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
        final: prev: {
          inherit (myOverlay) sf-mono-liga catppuccin-gtk catppuccin-folders catppuccin-cursors;
          sf-mono-liga-src = sf-mono-liga;
        }
      )
      nixpkgs-wayland.overlay
    ];
  };
in
  pkgs
