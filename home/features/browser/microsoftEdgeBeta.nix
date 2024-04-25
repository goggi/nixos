{
  lib,
  pkgs,
  ...
}: {
  home = {
    packages = [
      pkgs.microsoft-edge-beta
    ];
    persistence = {
      "/persist/home/gogsaan" = {
        allowOther = true;
        directories = [".config/microsoft-edge-beta"];
      };
    };
  };
  xdg.desktopEntries.microsoft-edge = {
    name = "Microsoft Edge (beta)";
    exec = "microsoft-edge-beta --enable-features=UseOzonePlatform --ozone-platform=wayland";
  };
}
