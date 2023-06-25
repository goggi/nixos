{
  description = "NixOS Configuration with Home-Manager & Flake";
  inputs = {
    # NixOS
    # nixpkgs.url = "/home/gogsaan/Projects/nix/nixpkgs";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    nixpkgsUnstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    # nixpkgs.url = "github:NixOS/nixpkgs/";
    impermanence.url = "github:nix-community/impermanence";
    nixpkgs-wayland = {
      url = "github:nix-community/nixpkgs-wayland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur.url = "github:nix-community/NUR";
    hardware.url = "github:nixos/nixos-hardware";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Hyprland
    hyprland = {
      # url = "github:hyprwm/Hyprland/6beb79f27b84c36b8b9ef5476d861a94a9071009";
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    xdg-portal-hyprland.url = "github:hyprwm/xdg-desktop-portal-hyprland";
    hyprland-contrib.url = "github:hyprwm/contrib";

    # Other
    vscode-server.url = "github:msteen/nixos-vscode-server";
    sops-nix.url = github:Mic92/sops-nix;
    nixpkgs-f2k.url = "github:fortuneteller2k/nixpkgs-f2k";
    devshell.url = "github:numtide/devshell";
    flake-utils.url = "github:numtide/flake-utils";
    bazecor.url = "github:gvolpe/bazecor-nix";

    # Non Flakes
    sf-mono-liga = {
      url = "github:shaunsingh/SFMono-Nerd-Font-Ligaturized";
      flake = false;
    };

    # rust-overlay = {
    #   url = "github:oxalica/rust-overlay";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    # theme
    # base16 = {
    #   url = "github:shaunsingh/base16.nix";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    # base16-oxocarbon = {
    #   url = "github:shaunsingh/base16-oxocarbon";
    #   flake = false;
    # };
  };

  outputs = {
    self,
    nixpkgs,
    bazecor,
    sops-nix,
    vscode-server,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    lib = nixpkgs.lib;
    inherit (builtins) mapAttrs elem;

    filterNixFiles = k: v: v == "regular" && lib.hasSuffix ".nix" k;
    importNixFiles = path:
      (lib.lists.forEach (lib.mapAttrsToList (name: _: path + ("/" + name))
          (lib.filterAttrs filterNixFiles (builtins.readDir path))))
      import;

    # Packages
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
        ];

        packageOverrides = super: {
          looking-glass-client = pkgs.callPackage ./pkgs/looking {};
          vscode = pkgs.callPackage ./pkgs/vscode/vscode.nix {};
        };
      };

      pkgs.config.allowBroken = pkgs: with pkgs; [kitty];

      # Overlays
      overlays = with inputs;
        [
          (
            final: _: let
              inherit (final) system;
            in {
              sf-mono-liga-src = sf-mono-liga;
              eww-wayland-git = eww.packages.${system}.eww-wayland;
            }
          )
          nur.overlay
          nixpkgs-wayland.overlay
          nixpkgs-f2k.overlays.default
        ]
        # Overlays from ./overlays directory
        ++ (importNixFiles ./overlays);
    };

    pkgsUnstable = import inputs.nixpkgsUnstable {
      inherit system;
      config = {
        allowBroken = true;
        allowInsecure = true;
        allowUnfree = true;
        tarball-ttl = 0;
      };
    };
  in rec {
    inherit lib pkgs pkgsUnstable;

    # nixos-configs with home-manager

    nixosConfigurations = import ./hosts inputs;

    devShells.${system}.default = pkgs.mkShell {
      sopsPGPKeyDirs = ["./keys"];
      sopsCreateGPGHome = true;
      nativeBuildInputs = [
        (pkgs.callPackage sops-nix {}).sops-import-keys-hook
      ];
    };

    # Default formatter for the entire repo
    formatter.${system} = pkgs.${system}.alejandra;
  };
}
# eww = {
#   url = "github:elkowar/eww";
#   inputs.nixpkgs.follows = "nixpkgs";
# };

