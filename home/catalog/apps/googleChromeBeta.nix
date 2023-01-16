{
  lib,
  pkgs,
  ...
}: {
  home = {
    packages = [
      pkgs.google-chrome-beta
    ];
    persistence = {
      "/persist/home/gogsaan" = {
        allowOther = true;
        directories = [".config/google-chrome-beta"];
      };
    };
  };
}
