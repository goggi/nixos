{
  lib,
  pkgs,
  ...
}: {
  home = {
    packages = [
      pkgs.equibop
    ];
    persistence = {
      "/persist/home/gogsaan" = {
        allowOther = true;
        directories = [".config/equibop"];
      };
    };
  };
}
