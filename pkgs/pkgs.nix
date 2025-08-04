{
  inputs,
  system,
  lib,
  ...
}: let
  inherit (builtins) mapAttrs;

  # Helper function to filter and import .nix files from a directory
  filterNixFiles = k: v: v == "regular" && lib.hasSuffix ".nix" k;
  importNixFiles = path:
    (lib.lists.forEach (lib.mapAttrsToList (name: _: path + ("/" + name))
        (lib.filterAttrs filterNixFiles (builtins.readDir path))))
    import;

  # Common nixpkgs configuration
  commonNixpkgsConfig = {
    allowUnfree = true;
  };

  # Import different nixpkgs channels with consistent configuration
  nixpkgsMaster = import inputs.nixpkgsMaster {
    inherit system;
    config = commonNixpkgsConfig;
  };

  nixpkgsUnstableSmall = import inputs.nixpkgsUnstableSmall {
    inherit system;
    config = commonNixpkgsConfig;
  };

  nixpkgsUnstable = import inputs.nixpkgsUnstable {
    inherit system;
    config = commonNixpkgsConfig;
  };

  # Permitted insecure packages list
  permittedInsecurePackages = [
    "nodejs-16.20.0"
    "nodejs-16.20.1"
    "nodejs-16.20.2"
    "electron-25.9.0"
    "electron-24.8.6"
    "freeimage-unstable-2021-11-01"
    "electron-27.3.11"
  ];

  # Package overrides configuration
  packageOverrides = super: {
    # External flake packages
    zen-browser = inputs.zen-browser.packages.${system}.default;
    # claude-desktop = inputs.claude-desktop.packages.${system}.claude-desktop-with-fhs;

    # Packages from different nixpkgs channels
    vivaldi = nixpkgsMaster.vivaldi;
    vivaldi-ffmpeg-codecs = nixpkgsMaster.vivaldi-ffmpeg-codecs;
    windsurf = nixpkgsMaster.windsurf;
    vscode = nixpkgsUnstableSmall.vscode;
    vencord = nixpkgsUnstableSmall.vencord;
    obsidian = nixpkgsUnstable.obsidian;

    # Local custom packages
    navicat = pkgs.callPackage ./active/navicat {};
    bibata-hyprcursor = pkgs.callPackage ./active/bibata {};
    cursor = pkgs.callPackage ./active/cursor {};
    bazecor = pkgs.callPackage ./active/bazecor {};
    starsector = pkgs.callPackage ./active/starsector {};
    thorium = pkgs.callPackage ./active/thorium {};
    k9s = pkgs.callPackage ./active/k9s {};
    satty = pkgs.callPackage ./active/satty {};
    # archi = pkgs.callPackage ./active/archi {};
  };

  # Overlays configuration
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

  # Main nixpkgs configuration
  pkgs = import inputs.nixpkgs {
    inherit system;

    config = {
      allowBroken = true;
      allowInsecure = true;
      allowUnfree = true;
      tarball-ttl = 0;
      permittedInsecurePackages = permittedInsecurePackages;
      packageOverrides = packageOverrides;
    };

    inherit overlays;
  };
in
  pkgs
