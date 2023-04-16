{
  lib,
  pkgs,
  ...
}: {
  home = {
    packages = [
      pkgs.lapce
    ];
    persistence = {
      "/persist/home/gogsaan" = {
        allowOther = true;
        directories = [".config/lapce-stable"];
      };
    };
  };
}
