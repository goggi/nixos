{
  description = "Rxyhn's NixOS Configuration with Home-Manager & Flake";

  inputs = {
    # NixOS
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # nixpkgsUnstableMaster.url = "github:nixos/nixpkgs/master";
    # nixpkgsUnstableMasterMine.url = "github:goggi/nixpkgs/master";
    impermanence.url = "github:nix-community/impermanence";
    nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";
    nur.url = "github:nix-community/NUR";
    hardware.url = "github:nixos/nixos-hardware";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Hyprland
    hyprland.url = "github:hyprwm/Hyprland/";
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

    pkgs = import inputs.nixpkgs {
      inherit system;
      config = {
        allowBroken = true;
        allowUnfree = true;
        tarball-ttl = 0;
        packageOverrides = super: {
          webcord = pkgs.callPackage ./pkgs/webcord {};
        };
      };

      pkgs.config.allowBroken = pkgs: with pkgs; [kitty];

      overlays = with inputs;
        [
          (
            final: _: let
              inherit (final) system;
            in
              {
                # Packages provided by flake inputs
                # crane-lib = crane.lib.${system};
              }
              // (with nixpkgs-f2k.packages.${system}; {
                # Overlays with f2k's repo
                awesome = awesome-git;
                picom = picom-git;
                wezterm = wezterm-git;
              })
              // {
                # Non Flakes
                sf-mono-liga-src = sf-mono-liga;
              }
          )
          nur.overlay
          nixpkgs-wayland.overlay
          nixpkgs-f2k.overlays.default
          # rust-overlay.overlays.default
        ]
        # Overlays from ./overlays directory
        ++ (importNixFiles ./overlays);
    };
  in rec {
    inherit lib pkgs;

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
