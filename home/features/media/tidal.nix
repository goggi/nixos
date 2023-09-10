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
      pkgs.tidal-dl
    ];
    persistence = {
      "/persist/home/gogsaan" = {
        allowOther = true;
        directories = [".config/tidal-hifi"];
        files = [
          ".config/.tidal-dl.json"
          ".config/.tidal-dl.token.json"
        ];
      };
    };
  };
}
