{
  lib,
  pkgs,
  ...
}: {
  home = {
    persistence = {
      "/persist/home/gogsaan" = {
        allowOther = true;
        directories = [".var" ".local/share/flatpak"];
      };
    };
  };
}
