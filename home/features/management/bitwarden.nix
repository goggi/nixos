{
  lib,
  pkgs,
  ...
}: {
  home = {
    packages = [
      # pkgs.goldwarden
      # pkgs.keyguard
      # pkgs.bitwarden-desktop
      # pkgs.bitwarden-cli
    ];

    persistence = {
      "/persist/home/gogsaan" = {
        allowOther = true;
        directories = [
          {
            directory = ".config/Bitwarden";
            method = "symlink";
          }
          {
            directory = ".config/goldwarden";
            method = "symlink";
          }
        ];
      };
    };
  };
}
