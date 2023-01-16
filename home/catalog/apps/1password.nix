{
  lib,
  pkgs,
  ...
}: {
  home = {
    packages = [
      pkgs._1password-gui
      pkgs._1password
    ];
    persistence = {
      "/persist/home/gogsaan" = {
        allowOther = true;
        directories = [".config/1Password"];
      };
    };
  };
}
