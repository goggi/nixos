{
  lib,
  pkgs,
  ...
}: {
  home = {
    packages = [
      pkgs.idasen
    ];

    persistence = {
      "/persist/home/gogsaan" = {
        allowOther = true;
        directories = [".config/idasen"];
      };
    };
  };
}
