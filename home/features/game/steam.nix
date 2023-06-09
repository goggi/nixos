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
        mangohud
      ];
  };
in {
  home = {
    sessionVariables = {
      STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";
    };
  };

  home.packages = with pkgs; [
    gamescope
    steam-with-pkgs
    protontricks
    protonup-ng
  ];
  home.persistence = {
    "/persist/games/gogsaan" = {
      allowOther = true;
      directories = [
        {
          directory = ".local/share/Paradox Interactive";
          method = "symlink";
        }
        {
          directory = ".cache/AMD";
          method = "symlink";
        }
        {
          directory = ".config/unity3d";
          method = "symlink";
        }
        {
          directory = ".cache/mesa_shader_cache";
          method = "symlink";
        }
        {
          directory = ".cache/mesa_shader_cache";
          method = "symlink";
        }
        {
          directory = ".paradoxlauncher";
          method = "symlink";
        }
        {
          directory = ".local/share/Steam";
          method = "symlink";
        }
      ];
    };
  };
}
