{
  lib,
  pkgs,
  ...
}: {
  home = {
    packages = [
      pkgs.parsec-bin
    ];

    persistence = {
      "/persist/home/gogsaan" = {
        allowOther = true;
        directories = [".parsec" ".parsec-persistent"];
      };
    };
  };
}
