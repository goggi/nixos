{
  lib,
  pkgs,
  ...
}: {
  home = {
    packages = [
      pkgs.vencord
    ];
    # persistence = {
    #   "/persist/home/gogsaan" = {
    #     allowOther = true;
    #     directories = [".config/tidal-hifi"];
    #   };
    # };
  };
}
