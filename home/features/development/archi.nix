{
  lib,
  pkgs,
  ...
}: {
  home = {
    packages = [
      pkgs.archi
    ];

    persistence = {
      "/persist/home/gogsaan" = {
        allowOther = true;
        directories = [".archi"];
      };
    };
  };
}
