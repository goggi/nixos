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
          {
            directory = ".var";
            method = "symlink";
          }
          {
            directory = ".local/share/flatpak";
            method = "symlink";
          }
        ];
      };
    };
  };
}
