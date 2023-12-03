{
  lib,
  pkgs,
  ...
}: {
  home = {
    packages = [
      pkgs.wavebox
    ];
    persistence = {
      "/persist/home/gogsaan" = {
        allowOther = true;
        directories = [".config/wavebox"];
      };
    };
  };
}
