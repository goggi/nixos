{
  config,
  pkgs,
  lib,
  ...
}: let
in {
  home.packages = with pkgs; [discord discocss];

  home.persistence = {
    "/persist/home/gogsaan".directories = [".config/discord"];
  };
}
