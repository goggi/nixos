{
  lib,
  pkgs,
  ...
}: {
  home = {
    packages = [
      pkgs.microsoft-edge-dev
    ];
    persistence = {
      "/persist/home/gogsaan" = {
        allowOther = true;
        directories = [".config/microsoft-edge-dev"];
      };
    };
  };
  xdg.desktopEntries.microsoft-edge = {
    name = "Microsoft Edge (dev)";
    exec = "microsoft-edge-dev --enable-features=UseOzonePlatform --ozone-platform=wayland";
  };
}
