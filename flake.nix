{
  description = "NixOS Configuration with Home-Manager & Flake";
  inputs = {
    # NixOS
    # nixpkgs.url = "/home/gogsaan/Projects/nix/nixpkgs";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

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
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    inherit (self) outputs;
    lib = nixpkgs.lib;
    system = "x86_64-linux";

    # forEachSystem = nixpkgs.lib.genAttrs [ "x86_64-linux" "aarch64-linux" ];
    # forEachPkgs = f: forEachSystem (sys: f nixpkgs.legacyPackages.${sys});

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
        # packageOverrides = super: {
        #   webcord = pkgs.callPackage ./pkgs/webcord {};
        # looking-glass-client = pkgs.callPackage ./pkgs/looking {};
        #   gtk-layer-shell = pkgs.callPackage ./pkgs/gtkLayerShell {};
        #   archi = pkgs.callPackage ./pkgs/archi {};
        # };
      };
    };

    mkNixos = modules:
      nixpkgs.lib.nixosSystem {
        inherit modules pkgs;
        specialArgs = {inherit inputs outputs pkgs;};
      };
    mkHome = modules: pkgs:
      home-manager.lib.homeManagerConfiguration {
        inherit modules pkgs;
        extraSpecialArgs = {inherit inputs outputs pkgs;};
      };
  in {
    nixosConfigurations = {
      # Desktops
      gza = mkNixos [./hosts/gza];
    };

    homeConfigurations = {
      # Desktops
      "gogsaan@gza" = mkHome [./home/gogsaan/gza.nix] nixpkgs.legacyPackages."x86_64-linux";
    };
  };

  # outputs = {
  #   self,
  #   nixpkgs,
  #   bazecor,
  #   sops-nix,
  #   vscode-server,
  #   ...
  # } @ inputs: let
  #   system = "x86_64-linux";
  #   lib = nixpkgs.lib;
  #   inherit (builtins) mapAttrs elem;

  #   # filterNixFiles = k: v: v == "regular" && lib.hasSuffix ".nix" k;
  #   # importNixFiles = path:
  #   #   (lib.lists.forEach (lib.mapAttrsToList (name: _: path + ("/" + name))
  #   #       (lib.filterAttrs filterNixFiles (builtins.readDir path))))
  #   #   import;

  #   # Packages
  #   pkgs = import inputs.nixpkgs {
  #     inherit system;
  #     config = {
  #       allowBroken = true;
  #       allowInsecure = true;
  #       allowUnfree = true;
  #       tarball-ttl = 0;
  #       permittedInsecurePackages = [
  #         "electron-21.4.0"
  #       ];
  #       packageOverrides = super: {
  #         webcord = pkgs.callPackage ./pkgs/webcord {};
  #         looking-glass-client = pkgs.callPackage ./pkgs/looking {};
  #         gtk-layer-shell = pkgs.callPackage ./pkgs/gtkLayerShell {};
  #         archi = pkgs.callPackage ./pkgs/archi {};
  #       };
  #     };

  #     pkgs.config.allowBroken = pkgs: with pkgs; [kitty];

  #     # Overlays
  #     # overlays = with inputs;
  #     #   [
  #     #     (
  #     #       final: _: let
  #     #         inherit (final) system;
  #     #       in {
  #     #         sf-mono-liga-src = sf-mono-liga;
  #     #       }
  #     #     )
  #     #     nur.overlay
  #     #     nixpkgs-wayland.overlay
  #     #     nixpkgs-f2k.overlays.default
  #     #   ]
  #     #   # Overlays from ./overlays directory
  #     #   ++ (importNixFiles ./overlays);
  #   };
  # # in rec {
  # #   inherit lib pkgs;

  # #   # nixos-configs with home-manager

  # #   nixosConfigurations = import ./hosts inputs;

  # #   devShells.${system}.default = pkgs.mkShell {
  # #     sopsPGPKeyDirs = ["./keys"];
  # #     sopsCreateGPGHome = true;
  # #     nativeBuildInputs = [
  # #       (pkgs.callPackage sops-nix {}).sops-import-keys-hook
  # #     ];
  # #   };

  # #   # Default formatter for the entire repo
  # #   formatter.${system} = pkgs.${system}.alejandra;
  # # };
}
