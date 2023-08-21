{
  inputs,
  system,
  ...
}: let
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
      };
    };
  };
in
  pkgs
