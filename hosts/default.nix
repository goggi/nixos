inputs: let
  inherit (inputs) self;
  inherit (self.lib) nixosSystem;

  sharedModules = [
    inputs.home-manager.nixosModules.home-manager
    {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        extraSpecialArgs = {inherit inputs self pkgsStable;};
        users.gogsaan = ../home/gogsaan/gza.nix;
      };
    }
  ];
in {
  gza = nixosSystem {
    modules =
      [
        ./gza
        inputs.hyprland.nixosModules.default
        inputs.vscode-server.nixosModule
        ({
          config,
          pkgs,
          pkgsStable,
          ...
        }: {
          services.vscode-server.enable = true;
          services.vscode-server.enableFHS = true;
        })
      ]
      ++ sharedModules;

    specialArgs = {inherit inputs;};
    system = "x86_64-linux";
  };
}
