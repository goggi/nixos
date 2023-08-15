{
  lib,
  pkgs,
  ...
}: {
  home = {
    packages = [
      pkgs.google-chrome
    ];
    persistence = {
      "/persist/home/gogsaan" = {
        allowOther = true;
        directories = [
          {
            directory = ".config/google-chrome";
            method = "symlink";
          }
        ];
      };
    };
  };
}
