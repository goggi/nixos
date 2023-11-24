{
  inputs = {
    # NixOS
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    impermanence.url = "github:nix-community/impermanence";
    nixpkgs-wayland = {
      url = "github:nix-community/nixpkgs-wayland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hardware.url = "github:nixos/nixos-hardware";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    fu.url = "github:numtide/flake-utils";

    # Hyprland
    hyprland = {
      # url = "github:hyprwm/Hyprland/751d2851cc270c3322ffe2eb83c156e4298a0c0e";
      # url = "github:hyprwm/Hyprland/bc7f6a7fe14e2ed748e4e2e4b326f57c6a28b4e6";
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland-contrib.url = "github:hyprwm/contrib";

    # Other
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
    bazecor,
    sops-nix,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    lib = nixpkgs.lib;
    inherit (builtins);
    pkgs = import ./pkgs/pkgs.nix {inherit inputs system lib builtins;};
  in {
    inherit lib pkgs;
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

  # nixConfig = {
  #   extra-substituters = [
  #     "https://nix-community.cachix.org"
  #     "https://helix.cachix.org"
  #     "https://fufexan.cachix.org"
  #     "https://nix-gaming.cachix.org"
  #     "https://hyprland.cachix.org"
  #     "https://cache.privatevoid.net"
  #   ];
  #   extra-trusted-public-keys = [
  #     "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
  #     "helix.cachix.org-1:ejp9KQpR1FBI2onstMQ34yogDm4OgU2ru6lIwPvuCVs="
  #     "fufexan.cachix.org-1:LwCDjCJNJQf5XD2BV+yamQIMZfcKWR9ISIFy5curUsY="
  #     "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
  #     "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
  #     "cache.privatevoid.net:SErQ8bvNWANeAvtsOESUwVYr2VJynfuc9JRwlzTTkVg="
  #   ];
  # };
}
