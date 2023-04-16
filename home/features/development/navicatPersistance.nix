{
  lib,
  pkgs,
  ...
}: {
  home = {
    persistence = {
      "/persist/home/gogsaan" = {
        allowOther = true;
        directories = [".config/navicat"];
      };
    };
  };
}
