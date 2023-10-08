{
  lib,
  pkgs,
  ...
}: {
  home = {
    packages = [
      pkgs.plex
      pkgs.plexamp
    ];
    persistence = {
      "/persist/home/gogsaan" = {
        allowOther = true;
        directories = [
          ".config/Plexamp"
          ".local/share/plex"
          ".local/share/Plexamp"
        ];
      };
    };
  };
}
