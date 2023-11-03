{
  lib,
  pkgs,
  ...
}: {
  home = {
    packages = [
      pkgs.wasabiwallet
    ];
    persistence = {
      "/persist/home/gogsaan" = {
        allowOther = true;
        directories = [".walletwasabi"];
      };
    };
  };
}
