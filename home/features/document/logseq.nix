{
  lib,
  pkgs,
  ...
}: {
  home = {
    packages = [pkgs.logseq];
    persistence = {
      "/persist/home/gogsaan" = {
        allowOther = true;
        directories = [".config/Logseq"];
      };
    };
  };
}
