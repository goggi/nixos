{
  lib,
  pkgs,
  ...
}: {
  home = {
    packages = [
      pkgs.neovim
    ];

    # persistence = {
    #   "/persist/home/gogsaan" = {
    #     allowOther = true;
    #     directories = [".config/k9s"];
    #   };
    # };
  };
}
