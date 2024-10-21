{
  appimageTools,
  lib,
  fetchurl,
  pkgs,
}: let
  name = "navicat";
  version = "17";
  # Minor versions are released using the same file name
  versionItems = builtins.splitVersion version;
  majorVersion = builtins.elemAt versionItems 0;

  appimageContents = appimageTools.extract {
    inherit name src;
  };

  src = fetchurl {
    url = "https://dn.navicat.com/download/navicat${majorVersion}-premium-en-x86_64.AppImage";
    hash = "sha256-A+JSvzt2E/zq5rajjmRlNFkxUGyu33fAkkBYkTMHcYM=";
  };
in
  appimageTools.wrapType1 rec {
    inherit name src;

    extraInstallCommands = ''
      mkdir -p $out/share/applications
      ln -s ${appimageContents}/navicat.desktop $out/share/applications/navicat.desktop
      cp -r ${appimageContents}/usr/share/icons/ $out/share/

      # Add the reset script
      mkdir -p $out/bin
      cat << 'EOF' > $out/bin/navicat_reset.sh
      #!/usr/bin/env bash

      # Author: NakamuraOS <https://github.com/nakamuraos>
      # Latest update: 06/24/2024
      # Tested on Navicat 15.x, 16.x, 17.x on Debian, Ubuntu.

      set -e  # Exit immediately if a command exits with a non-zero status
      set -u  # Treat unset variables as an error
      set -o pipefail  # Return the exit status of the last command in the pipe that failed

      BGRED="\e[1;97;41m"
      ENDCOLOR="\e[0m"

      echo -e "Report issues:\n> https://gist.github.com/nakamuraos/717eb99b5e145ed11cd754ad3714b302\n"
      echo -e "Reset trial \e[1mNavicat Premium\e[0m:"
      read -p "Are you sure? (y/N) " -r
      echo
      if [[ $REPLY =~ ^[Yy]([eE][sS])?$ ]]
      then
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
      else
        echo "Aborted."
      fi
      EOF
      chmod +x $out/bin/navicat_reset.sh
    '';

    extraPkgs = pkgs: [];

    meta = with lib; {
      description = "Navicat Premium 17";
      homepage = "https://www.navicat.com/";
      license = with licenses; [unfree];
      platforms = ["x86_64-linux"];
    };
  }
