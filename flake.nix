{
  inputs = {
    # NixOS

    # Local Unstable nixpkgs repository at ../nixpkgs
    nixpkgsUnstableSmall = {
      url = "github:NixOS/nixpkgs/nixos-unstable-small";
    };
    nixpkgsUnstable = {
      url = "github:NixOS/nixpkgs/nixos-unstable-small";
    };
    nixpkgsStable = {
      url = "github:NixOS/nixpkgs/nixos-24.05";
    };
    nixpkgs = {
      # url = "github:NixOS/nixpkgs/68b021b3244d6464671494eb83015deeb0fe294a";
      # url = "github:NixOS/nixpkgs/nixos-24.11";
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
    impermanence.url = "github:nix-community/impermanence";
    nixpkgs-wayland = {
      url = "github:nix-community/nixpkgs-wayland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hardware.url = "github:nixos/nixos-hardware";
    home-manager = {
      # url = "github:nix-community/home-manager/release-24.11";
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
    };
    fu = {
      url = "github:numtide/flake-utils";
    };

    # Hyprland
    hyprland = {
      # url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
      
      
      url = "github:hyprwm/Hyprland";

      # Currently works
      # url = "github:goggi/Hyprland/23be7fc49aee0668c93762cdb342120eef65f2d4";
      # inputs.nixpkgs.follows = "nixpkgs";
    };
















    # hyprland-contrib.url = "github:hyprwm/contrib";
    # Other
    playwright.url = "github:pietdevries94/playwright-web-flake";
    zen-browser.url = "github:youwen5/zen-browser-flake";
    # zen-browser.url = "github:goggi/zen-browser-flake";
    zen-browser.inputs.nixpkgs.follows = "nixpkgs";
    catppuccin.url = "github:catppuccin/nix";
    lug.url = "github:LovingMelody/lug-helper/20806da463f9e069fdf98841ca2c5d69146cb163";
    nix-gaming.url = "github:fufexan/nix-gaming";
    # nix-doom-emacs.url = "github:nix-community/nix-doom-emacs";
    sops-nix.url = github:Mic92/sops-nix;
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

    formatter = pkgs.${system}.alejandra;
    devShells.${system}.default = pkgs.mkShell {
      sopsPGPKeyDirs = ["./keys"];
      sopsCreateGPGHome = true;
      nativeBuildInputs = [
        (pkgs.callPackage sops-nix {}).sops-import-keys-hook
      ];
    };
  };
}
