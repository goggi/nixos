{
  appimageTools,
  lib,
  pkgs,
  makeWrapper,
  stdenv,
}: let
  name = "navicat";
  version = "16";

  appimageContents = appimageTools.extract {
    inherit name src;
  };

  src = ./navicat16-premium-en.AppImage;
in
  appimageTools.wrapType2 {
    inherit name src;

    extraInstallCommands = ''
      mkdir -p $out/share/applications
      cp ${appimageContents}/navicat.desktop $out/share/applications/${name}.desktop
      cp -r ${appimageContents}/usr/share/icons $out/share/
      substituteInPlace $out/share/applications/${name}.desktop \
        --replace 'Exec=AppRun' 'Exec=${name}'

      # Add the reset script
      mkdir -p $out/bin
      cat << 'EOF' > $out/bin/navicat_reset.sh
      #!/usr/bin/env bash
      # ... (rest of the reset script)
      EOF
      chmod +x $out/bin/navicat_reset.sh
    '';

    extraPkgs = pkgs:
      with pkgs; [
        zstd # Changed from libzstd to zstd
        stdenv.cc.cc.lib
        zlib
        xorg.libX11
        xorg.libXi
        xorg.libXrender
        xorg.libXfixes
        xorg.libXcursor
        xorg.libXcomposite
        xorg.libXdamage
        xorg.libXext
        xorg.libXrandr
        xorg.libXtst
        libGL
        nss
        nspr
        atk
        at-spi2-atk
        cairo
        cups
        dbus
        expat
        fontconfig
        freetype
        gdk-pixbuf
        glib
        gtk3
        libdrm
        libxkbcommon
        mesa
        pango
      ];

    meta = with lib; {
      description = "Navicat Premium 16";
      homepage = "https://www.navicat.com/";
      license = licenses.unfree;
      platforms = ["x86_64-linux"];
      mainProgram = "navicat";
    };
  }
