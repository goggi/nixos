{
  lib,
  pkgs,
  ...
}: {
  home = {
    packages = [
      pkgs.docker-compose
    ];
    persistence = {
      "/persist/home/gogsaan" = {
        allowOther = true;
        directories = [
          ".local/share/docker"
          ".docker"
        ];
      };
    };
  };
}
