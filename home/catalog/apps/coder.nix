{
  lib,
  pkgs,
  ...
}: {
  home = {
    packages = [
      pkgs.coder
    ];

    persistence = {
      "/persist/home/gogsaan" = {
        allowOther = true;
        directories = [".config/coderv2"];
      };
    };
  };
}
