{
  lib,
  pkgs,
  ...
}: {
  home = {
    packages = [
      pkgs.wayvnc
    ];
    persistence = {
      "/persist/home/gogsaan" = {
        allowOther = true;
        directories = [".config/wayvnc"];
      };
    };
  };
}
