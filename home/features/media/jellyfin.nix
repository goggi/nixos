{
  lib,
  pkgs,
  ...
}: {
  home = {
    packages = [
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
