{
  lib,
  pkgs,
  ...
}: {
  home = {
    packages = [
      pkgs.nemo
    ];

    persistence = {
      "/persist/home/gogsaan" = {
        allowOther = true;
        directories = [".config/nemo"];
      };
    };
  };
}
