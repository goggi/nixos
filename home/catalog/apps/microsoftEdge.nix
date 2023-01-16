{
  lib,
  pkgs,
  ...
}: {
  home = {
    packages = [
      pkgs.microsoft-edge
    ];
    persistence = {
      "/persist/home/gogsaan" = {
        allowOther = true;
        directories = [".config/microsoft-edge"];
      };
    };
  };
  xdg.desktopEntries.microsoft-edge = {
    name = "Microsoft Edge";
    exec = "microsoft-edge --enable-features=UseOzonePlatform --ozone-platform=wayland";
  };
}
