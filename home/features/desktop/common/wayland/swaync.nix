{
  lib,
  pkgs,
  ...
}: {
  home = {
    packages = [
      pkgs.swaynotificationcenter
    ];
    persistence = {
      "/persist/home/gogsaan" = {
        allowOther = true;
        directories = [".config/swaync"];
      };
    };
  };
}
