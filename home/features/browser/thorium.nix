{
  lib,
  pkgs,
  ...
}: {
  home = {
    packages = [
      pkgs.thorium
    ];
    persistence = {
      "/persist/home/gogsaan" = {
        allowOther = true;
        directories = [".config/thorium"];
      };
    };
  };
}
