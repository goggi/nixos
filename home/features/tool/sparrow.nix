{
  lib,
  pkgs,
  ...
}: {
  home = {
    packages = [
      pkgs.sparrow
    ];
    persistence = {
      "/persist/home/gogsaan" = {
        allowOther = true;
        directories = [".sparrow"];
      };
    };
  };
}
