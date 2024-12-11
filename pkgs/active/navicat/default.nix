{
  lib,
  pkgs,
  appimageTools,
  makeWrapper,
  stdenv,
}: let
  pname = "navicat";
  version = "16";

  src = ./navicat16-premium-en.AppImage;

  # Define a custom extraction process using a different tool
  extractedDir = pkgs.runCommand "extract-navicat" {
    buildInputs = [ pkgs.bash pkgs.squashfsTools ];
  } ''
    mkdir -p $out
    unsquashfs -d $out ${src}
  '';

in
  appimageTools.wrapType2 {
    name = "${pname}-${version}";
    inherit src;

    extraInstallCommands = ''
      mkdir -p $out/share/applications
      cp ${extractedDir}/navicat.desktop $out/share/applications/${pname}.desktop
      cp -r ${extractedDir}/usr/share/icons $out/share/
      substituteInPlace $out/share/applications/${pname}.desktop \
        --replace 'Exec=AppRun' 'Exec=${pname}'

      # Add the reset script
      mkdir -p $out/bin
      cat << 'EOF' > $out/bin/navicat_reset.sh
      #!/usr/bin/env bash
        echo "Starting reset..."
        DATE=$(date '+%Y%m%d_%H%M%S')
        # Backup
        echo "=> Creating a backup..."
        cp ~/.config/dconf/user ~/.config/dconf/user.$DATE.bk
        echo "The user dconf backup was created at $HOME/.config/dconf/user.$DATE.bk"
        cp ~/.config/navicat/Premium/preferences.json ~/.config/navicat/Premium/preferences.json.$DATE.bk
        echo "The Navicat preferences backup was created at $HOME/.config/navicat/Premium/preferences.json.$DATE.bk"
        # Clear data in dconf
        echo "=> Resetting..."
        dconf reset -f /com/premiumsoft/navicat-premium/
        echo "The user dconf data was reset"
        # Remove data fields in config file
        sed -i -E 's/,?"([A-F0-9]+)":\{([^\}]+)},?//g' ~/.config/navicat/Premium/preferences.json
        echo "The Navicat preferences was reset"
        # Done
        echo "Done."
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
