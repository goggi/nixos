{
  pkgs,
  lib,
  ...
}: let
  steam-with-pkgs = pkgs.steam.override {
    extraPkgs = pkgs:
      with pkgs; [
        xorg.libXcursor
        xorg.libXi
        xorg.libXinerama
        xorg.libXScrnSaver
        libpng
        libpulseaudio
        libvorbis
        stdenv.cc.cc.lib
        libkrb5
        keyutils
      ];
  };
in {
  home = {
    sessionVariables = {
      STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";
    };
  };

  home.packages = with pkgs; [
    steam-with-pkgs
    protontricks
    protonup-ng
  ];
  home.persistence = {
    "/persist/games/gogsaan" = {
      allowOther = true;
      directories = [
        ".local/share/Paradox Interactive"
        ".cache/AMD"
        ".config/unity3d"
        ".cache/mesa_shader_cache"
        ".paradoxlauncher"
        {
          directory = ".local/share/Steam";
          method = "symlink";
        }
      ];
    };
  };
}
