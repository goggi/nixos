{
  lib,
  pkgs,
  ...
}: {
  home = {
    packages = [
      pkgs.brave
    ];
    persistence = {
      "/persist/home/gogsaan" = {
        allowOther = true;
        directories = [".config/BraveSoftware/Brave-Browser"];
      };
    };
  };
  # xdg.desktopEntries.microsoft-edge = {
  #   name = "Microsoft Edge";
  #   exec = "microsoft-edge --enable-features=UseOzonePlatform --ozone-platform=wayland";
  # };
}
