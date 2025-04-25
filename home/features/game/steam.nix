{
  pkgs,
  lib,
  config,
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
        gamescope
      ];
  };

  gamescope-cmd = lib.concatStringsSep " " [
    (lib.getExe pkgs.gamescope)
    "--output-width 2560"
    "--output-height 1080"
    "--framerate 120"
    "--framerate-limit 120"
    "--adaptive-sync"
    "--expose-wayland"
    "--hdr-enabled"
    "--steam"
  ];
  
  steam-cmd = lib.concatStringsSep " " [
    "steam"
    "steam://open/bigpicture"
  ];
in {
  home.packages = [
    steam-with-pkgs
    pkgs.gamescope
    pkgs.protontricks
  ];
  
  xdg.desktopEntries = {
    steam-session = {
      name = "Steam Session";
      exec = "${gamescope-cmd} -- ${steam-cmd}";
      type = "Application";
    };
  };
  
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
