{
  lib,
  pkgs,
  ...
}: {
  home = {
    packages = [
      pkgs.gnome-keyring
    ];

    persistence = {
      "/persist/home/gogsaan" = {
        allowOther = true;
        directories = [".local/share/keyrings"];
      };
    };
  };
}
