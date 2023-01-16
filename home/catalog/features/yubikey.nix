{
  lib,
  pkgs,
  ...
}: {
  home = {
    packages = [
      pkgs.yubioath-flutter
      pkgs.yubikey-manager-qt
      pkgs.yubikey-agent
    ];
    persistence = {
      "/persist/home/gogsaan" = {
        allowOther = true;
        directories = [".config/Yubico"];
      };
    };
  };
}
