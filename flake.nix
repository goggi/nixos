{
  inputs = {
    # NixOS
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
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

    # Hyprland
    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland-contrib.url = "github:hyprwm/contrib";

    # Other
    sops-nix.url = github:Mic92/sops-nix;
    devshell.url = "github:numtide/devshell";
    flake-utils.url = "github:numtide/flake-utils";
    bazecor.url = "github:gvolpe/bazecor-nix";

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
    ...
  } @ inputs: let
    system = "x86_64-linux";
    lib = nixpkgs.lib;
    inherit (builtins);

    pkgs = import ./pkgs.nix {inherit inputs system lib builtins;};
    # # This function imports all nix files in a directory
    # filterNixFiles = k: v: v == "regular" && lib.hasSuffix ".nix" k;
    # importNixFiles = path:
    #   (lib.lists.forEach (lib.mapAttrsToList (name: _: path + ("/" + name))
    #       (lib.filterAttrs filterNixFiles (builtins.readDir path))))
    #   import;
    # # Packages
    # pkgs = import inputs.nixpkgs {
    #   inherit system;
    #   config = {
    #     allowBroken = true;
    #     allowInsecure = true;
    #     allowUnfree = true;
    #     tarball-ttl = 0;
    #     permittedInsecurePackages = [
    #       # "electron-21.4.0"
    #       "nodejs-16.20.0"
    #       "nodejs-16.20.1"
    #       "nodejs-16.20.2"
    #     ];
    #     packageOverrides = super: {
    #       looking-glass-client = pkgs.callPackage ./pkgs/looking {};
    #       vscode = pkgs.callPackage ./pkgs/vscode/vscode.nix {};
    #     };
    #   };
    #   # Overlays
    #   overlays = with inputs;
    #     [
    #       (
    #         final: _: let
    #           inherit (final) system;
    #         in {
    #           sf-mono-liga-src = sf-mono-liga;
    #         }
    #       )
    #       nixpkgs-wayland.overlay
    #     ]
    #     ++ (importNixFiles ./overlays);
    # };
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
}
