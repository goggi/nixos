{
  lib,
  pkgs,
  ...
}: {
  home = {
    packages = [
      pkgs.webcord
    ];
    persistence = {
      "/persist/home/gogsaan" = {
        allowOther = true;
        directories = [".config/WebCord"];
      };
    };
  };
}
