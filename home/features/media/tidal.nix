{
  lib,
  pkgs,
  ...
}: {
  home = {
    packages = [
      # pkgs._1password-gui
      # {
      #   enable = true;
      #   polkitPolicyOwners = ["gogsaan"];
      # }
      pkgs.tidal-hifi
    ];
    persistence = {
      "/persist/home/gogsaan" = {
        allowOther = true;
        directories = [".config/tidal-hifi"];
      };
    };
  };
}
