{
  lib,
  pkgs,
  ...
}: {
  home = {
    packages = [
      pkgs.navicat
    ];

    persistence = {
      "/persist/home/gogsaan" = {
        allowOther = true;
        directories = [".config/navicat"];
      };
    };
  };
}
