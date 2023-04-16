{
  lib,
  pkgs,
  ...
}: {
  home = {
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
