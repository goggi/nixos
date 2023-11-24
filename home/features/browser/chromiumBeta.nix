{
  lib,
  pkgs,
  ...
}: {
  home = {
    packages = [
      pkgs.chromiumBeta
    ];
    persistence = {
      "/persist/home/gogsaan" = {
        allowOther = true;
        directories = [".config/chromium-beta"];
      };
    };
  };
}
