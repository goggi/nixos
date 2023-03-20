{
  lib,
  pkgs,
  ...
}: {
  home = {
    packages = [
      pkgs.prismlauncher-qt5
    ];

    persistence = {
      "/persist/home/gogsaan" = {
        allowOther = true;
        directories = [".local/share/PrismLauncher"];
      };
    };
  };
}
