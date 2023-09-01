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
      pkgs.jellyfin-web
      pkgs.jellyfin
    ];
    # persistence = {
    #   "/persist/home/gogsaan" = {
    #     allowOther = true;
    #     directories = [".config/tidal-hifi"];
    #   };
    # };
  };
}
