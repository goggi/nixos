{
  lib,
  pkgs,
  ...
}: {
  home = {
    packages = [
      pkgs.prismlauncher
    ];

    persistence = {
      "/persist/home/gogsaan" = {
        allowOther = true;
        directories = [".local/share/PrismLauncher"];
      };
    };
  };
}
