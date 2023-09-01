{
  lib,
  pkgs,
  ...
}: {
  home = {
    packages = [
      pkgs.webcord-vencord
    ];
    persistence = {
      "/persist/home/gogsaan" = {
        allowOther = true;
        directories = [".config/WebCord"];
      };
    };
  };
}
