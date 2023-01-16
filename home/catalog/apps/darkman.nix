{
  lib,
  pkgs,
  ...
}: {
  # xdg.configFile."darkman/config.yaml".text = import ./cfgs/darkman/darkman.nix;
  # xdg.dataFile."dark-mode.d/gtk-theme.sh".text = import ./cfgs/darkman/light/gtk-theme.nix;

  # home = {
  #   packages = [
  #     pkgs.darkman
  #   ];
  #   persistence = {
  #     "/persist/home/gogsaan" = {
  #       allowOther = true;
  #       directories = [".config/1Password"];
  #     };
  #   };
  # };
}
