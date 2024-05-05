{
  lib,
  pkgs,
  ...
}: {
  home = {
    packages = [
      pkgs.chromium
    ];
    persistence = {
      "/persist/home/gogsaan" = {
        allowOther = true;
        directories = [".config/chromium"];
      };
    };
  };
  xdg.desktopEntries.chromium = {
    name = "Chromium";
    exec = "chromium --enable-features=UseOzonePlatform --ozone-platform=wayland";
  };
}
