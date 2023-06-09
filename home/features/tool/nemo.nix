{
  lib,
  pkgs,
  ...
}: {
  home = {
    packages = [
      pkgs.cinnamon.nemo
    ];

    persistence = {
      "/persist/home/gogsaan" = {
        allowOther = true;
        directories = [".config/nemo"];
      };
    };
  };
}
