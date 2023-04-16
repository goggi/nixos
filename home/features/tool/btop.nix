{
  lib,
  pkgs,
  ...
}: {
  home = {
    packages = [
      pkgs.btop
    ];

    persistence = {
      "/persist/home/gogsaan" = {
        allowOther = true;
        directories = [".config/btop"];
      };
    };
  };
}
