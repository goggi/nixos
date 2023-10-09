{
  lib,
  pkgs,
  ...
}: {
  home = {
    packages = [
      pkgs.starsector
      pkgs.xorg.xrandr
    ];

    persistence = {
      "/persist/home/gogsaan" = {
        allowOther = true;
        directories = [".config/starsector"];
      };
    };
  };
}
