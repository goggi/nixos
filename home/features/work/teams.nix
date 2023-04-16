{
  lib,
  pkgs,
  ...
}: {
  home = {
    packages = [
      pkgs.teams
    ];

    persistence = {
      "/persist/home/gogsaan" = {
        allowOther = true;
        directories = [".config/Microsoft"];
      };
    };
  };
}
