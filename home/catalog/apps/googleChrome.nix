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
        directories = [".config/google-chrome-stable"];
      };
    };
  };
}
