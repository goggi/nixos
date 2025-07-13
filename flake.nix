{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgsMaster.url = "github:NixOS/nixpkgs";
    nixpkgsUnstableSmall.url = "github:NixOS/nixpkgs/nixos-unstable-small";
    nixpkgsUnstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    hardware.url = "github:nixos/nixos-hardware";
    impermanence.url = "github:nix-community/impermanence";
    
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts.url = "github:hercules-ci/flake-parts";
    fu.url = "github:numtide/flake-utils";

    hyprland.url = "github:hyprwm/Hyprland";
    
    nixpkgs-wayland = {
      url = "github:nix-community/nixpkgs-wayland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    playwright.url = "github:pietdevries94/playwright-web-flake";
    
    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    catppuccin.url = "github:catppuccin/nix";
    lug.url = "github:LovingMelody/lug-helper/20806da463f9e069fdf98841ca2c5d69146cb163";
    nix-gaming.url = "github:fufexan/nix-gaming";
    sops-nix.url = "github:Mic92/sops-nix";
    devshell.url = "github:numtide/devshell";
    bazecor.url = "github:gvolpe/bazecor-nix";
    
    sf-mono-liga = {
      url = "github:shaunsingh/SFMono-Nerd-Font-Ligaturized";
      flake = false;
    };
  };

  outputs = {
    self,
    nixpkgs,
    sops-nix,
    hyprland,
    catppuccin,
    zen-browser,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    lib = nixpkgs.lib;
    inherit (self) outputs;
    pkgs = import ./pkgs/pkgs.nix {inherit inputs system lib builtins;};
  in {
    inherit lib pkgs;

    homeManagerModules = import ./modules/home-manager;
    nixosConfigurations = import ./hosts inputs;

    formatter.${system} = pkgs.alejandra;
    
    devShells.${system}.default = pkgs.mkShell {
      sopsPGPKeyDirs = ["./keys"];
      sopsCreateGPGHome = true;
      nativeBuildInputs = [
        (pkgs.callPackage sops-nix {}).sops-import-keys-hook
      ];
    };
  };
}
