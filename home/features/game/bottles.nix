{
  lib,
  pkgs,
  ...
}: {
  home = {
    packages = [
      pkgs.bottles
    ];

    persistence = {
      "/persist/home/gogsaan" = {
        allowOther = true;
        directories = [".local/share/bottles"];
      };
    };
  };
}
