{
  lib,
  pkgs,
  ...
}: {
  home = {
    packages = [pkgs.signal-desktop];
    persistence = {
      "/persist/home/gogsaan" = {
        allowOther = true;
        directories = [".config/Signal"];
      };
    };
  };
}
