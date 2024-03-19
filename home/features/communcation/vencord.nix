{
  lib,
  pkgs,
  ...
}: {
  home = {
    packages = [
      pkgs.vesktop
    ];
    persistence = {
      "/persist/home/gogsaan" = {
        allowOther = true;
        directories = [".config/vesktop"];
      };
    };
  };
}
