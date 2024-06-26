{
  inputs = {
    # NixOS

    # Local Unstable nixpkgs repository at ../nixpkgs
    # nixpkgsUnstable = {
    #   url = "/persist/home/gogsaan/Projects/private/nix/nixpkgs";
    # };

    nixpkgs = {
      #url = "github:NixOS/nixpkgs/nixos-unstable-small";
      #url = "github:NixOS/nixpkgs/nixos-unstable";

      url = "github:NixOS/nixpkgs/nixos-24.05";
    };
    impermanence.url = "github:nix-community/impermanence";
    nixpkgs-wayland = {
      url = "github:nix-community/nixpkgs-wayland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hardware.url = "github:nixos/nixos-hardware";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      # url = "github:nix-community/home-manager";/
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
      url = "github:hyprwm/Hyprland/e8e02e81e84bb04efa0c926361ec80c60744f665";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # hyprland-contrib.url = "github:hyprwm/contrib";

    # Other
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
