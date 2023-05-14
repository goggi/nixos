{
  description = "NixOS Configuration with Home-Manager & Flake";
  inputs = {
    # NixOS
    # nixpkgs.url = "/home/gogsaan/Projects/nix/nixpkgs"
    # nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-22.11";

    impermanence.url = "github:nix-community/impermanence";

    nixpkgs-wayland = {
      url = "github:nix-community/nixpkgs-wayland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur.url = "github:nix-community/NUR";
    hardware.url = "github:nixos/nixos-hardware";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Hyprland
    hyprland = {
      url = "github:hyprwm/Hyprland";
      # inputs.nixpkgs.follows = "nixpkgs";
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

    # nix-colors.url = "github:misterio77/nix-colors";

    # Non Flakes
    sf-mono-liga = {
      url = "github:shaunsingh/SFMono-Nerd-Font-Ligaturized";
      flake = false;
    };
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
          "electron-21.4.0"
        ];
        packageOverrides = super: {
          webcord = pkgs.callPackage ./pkgs/webcord {};
          looking-glass-client = pkgs.callPackage ./pkgs/looking {};
          gtk-layer-shell = pkgs.callPackage ./pkgs/gtkLayerShell {};
          archi = pkgs.callPackage ./pkgs/archi {};
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
            }
          )
          nur.overlay
          nixpkgs-wayland.overlay
          nixpkgs-f2k.overlays.default
        ]
        # Overlays from ./overlays directory
        ++ (importNixFiles ./overlays);
    };

    pkgsStable = import inputs.nixpkgs-stable {
      inherit system;
      config = {
        allowBroken = true;
        allowInsecure = true;
        allowUnfree = true;
      };
    };
  in rec {
    inherit lib pkgs pkgsStable;

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
