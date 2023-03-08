{
  lib,
  pkgs,
  ...
}: {
  home = {
    packages = [
      pkgs.nomacs
    ];
    persistence = {
      "/persist/home/gogsaan" = {
        allowOther = true;
        directories = [".config/nomacs"];
      };
    };
  };
}
