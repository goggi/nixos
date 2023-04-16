{
  lib,
  pkgs,
  ...
}: {
  home = {
    packages = [
      pkgs.taskwarrior
      pkgs.taskwarrior-tui
    ];

    # persistence = {
    #   "/persist/home/gogsaan" = {
    #     allowOther = true;
    #     directories = [".config/k9s"];
    #   };
    # };
  };
}
