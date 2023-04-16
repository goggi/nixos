{
  lib,
  pkgs,
  ...
}: {
  home = {
    packages = [
      (pkgs.vivaldi.override {
        proprietaryCodecs = true;
        enableWidevine = true;
      })
      pkgs.vivaldi-ffmpeg-codecs
      # pkgs.widevine-cdm
    ];
    persistence = {
      "/persist/home/gogsaan" = {
        allowOther = true;
        directories = [".config/vivaldi"];
      };
    };
  };

  # xdg.desktopEntries.vivaldi = {
  #   name = "Vivaldi";
  #   exec = "vivaldi --enable-features=UseOzonePlatform --ozone-platform=wayland";
  # };
}
