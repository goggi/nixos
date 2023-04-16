{
  lib,
  pkgs,
  ...
}: {
  home = {
    packages = [
      pkgs.qutebrowser
    ];

    persistence = {
      "/persist/home/gogsaan" = {
        allowOther = true;
        directories = [".config/qutebrowser"];
      };
    };
  };
}
