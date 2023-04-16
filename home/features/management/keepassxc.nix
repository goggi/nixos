{
  lib,
  pkgs,
  ...
}: {
  home = {
    packages = [
      pkgs.keepassxc
    ];

    persistence = {
      "/persist/home/gogsaan" = {
        allowOther = true;
        directories = [".config/keepassxc" ".cache/keepassxc"];
      };
    };
  };
}
