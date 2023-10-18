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
        directories = [
          {
            directory = ".config/starsector";
            method = "symlink";
          }
        ];
      };
    };
  };
}
