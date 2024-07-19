inputs: let
  inherit (inputs) self;
  inherit (self.lib) nixosSystem;
  sharedModules = [
    inputs.catppuccin.nixosModules.catppuccin

    inputs.home-manager.nixosModules.home-manager
    {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        extraSpecialArgs = {inherit inputs self;};
        users.gogsaan = ../home/gogsaan/gza.nix;
      };
    }
  ];
in {
  gza = nixosSystem {
    modules =
      [./gza]
      ++ sharedModules;
    specialArgs = {inherit inputs;};
    system = "x86_64-linux";
  };
}
