{
  lib,
  pkgs,
  ...
}: {
  home = {
    packages = [
      pkgs.prismlauncher
      pkgs.lunar-client
    ];

    persistence = {
      "/persist/home/gogsaan" = {
        allowOther = true;
        directories = [".local/share/PrismLauncher" ".lunarclient" ".minecraft"];
      };
    };
  };
}
