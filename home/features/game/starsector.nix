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
            directory = ".local/share/starsector";
            method = "symlink";
          }
        ];
      };
    };
  };
}
