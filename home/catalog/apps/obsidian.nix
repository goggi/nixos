{
  lib,
  pkgs,
  ...
}: {
  home = {
    packages = [pkgs.obsidian];
    persistence = {
      "/persist/home/gogsaan" = {
        allowOther = true;
        directories = [".config/obsidian"];
      };
    };
  };
}
