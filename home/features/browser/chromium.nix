  lib,
  pkgs,
  ...
}: {
  home = {
    packages = [
      pkgs.chromium
    ];
    persistence = {
      "/persist/home/gogsaan" = {
        allowOther = true;
        directories = [".config/chromium"];
      };
    };
  };
}
