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
        directories = [".config/microsoft-edge"];
      };
    };
  };
  xdg.desktopEntries.microsoft-edge-dev = {
    name = "Microsoft Edge Dev";
    exec = "microsoft-edge --enable-features=UseOzonePlatform --ozone-platform=wayland";
  };
}
