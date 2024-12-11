{
  lib,
  fetchzip,
  libGL,
  makeWrapper,
  openal,
  stdenv,
  xorg,
  openjdk23,
  copyDesktopItems,
  makeDesktopItem,
  writeScript,
}: let
  kitsunebi = fetchzip {
    url = "https://github.com/Yumeris/Mikohime_Repo/releases/download/26.4d/Kitsunebi_23_R26.4f_097a-RC11_linux.zip";
    sha256 = "1lyih2ijf0j3a9665yn5azgcz2i700mwb38v87il0r58pqmki2bm";
    stripRoot = false;
  };

  # Tips for mass changing the paths: find ./ -type f -name '*_Normal.*' -exec bash -c 'mv "$0" "${0/_Normal./_normal.}"' {} \;

  # Create the launch script with correct game directory arguments

  launchScript = writeScript "starsector-launch" ''
    #! /bin/bash
    JAVA_PATH=$(find '${openjdk23}' -name java -type f)
    if [ -z "$JAVA_PATH" ]; then
      echo "Java not found!"
      exit 1
    fi
    GAME_DIR="''${XDG_DATA_HOME}/.local/share/starsectors"
    mkdir -p "$GAME_DIR"
    "$JAVA_PATH" @./Miko_R3.txt
  '';

  vmparams_file = "${kitsunebi}/1. Pick VMParam Size Here/16GB (Sure)/Miko_R3.txt";
in
  stdenv.mkDerivation rec {
    pname = "starsector";
    version = "0.97a-RC11";

    src = fetchzip {
      url = "https://f005.backblazeb2.com/file/fractalsoftworks/release/starsector_linux-${version}.zip";
      sha256 = "sha256-KT4n0kBocaljD6dTbpr6xcwy6rBBZTFjov9m+jizDW4=";
    };

    nativeBuildInputs = [
      copyDesktopItems
      makeWrapper
    ];

    buildInputs = [
      xorg.libXxf86vm
      openal
      libGL
    ];

    dontBuild = true;

    desktopItems = [
      (makeDesktopItem {
        name = "starsector";
        exec = "starsector";
        icon = "starsector";
        comment = meta.description;
        genericName = "starsector";
        desktopName = "Starsector";
        categories = ["Game"];
      })
    ];

    postPatch = ''
      if [ -f "${vmparams_file}" ]; then
        cp -v "${vmparams_file}" ./Miko_R3.txt

        # Patch the VM parameters file
        sed -i 's/^-Dcom\.fs\.starfarer\.settings\.paths\.saves=.*/-Dcom.fs.starfarer.settings.paths.saves=\/home\/gogsaan\/.local\/share\/starsector\/saves/' ./Miko_R3.txt
        sed -i 's/^-Dcom\.fs\.starfarer\.settings\.paths\.screenshots=.*/-Dcom.fs.starfarer.settings.paths.screenshots=\/home\/gogsaan\/.local\/share\/starsector\/screenshots/' ./Miko_R3.txt
        sed -i 's/^-Dcom\.fs\.starfarer\.settings\.paths\.mods=.*/-Dcom.fs.starfarer.settings.paths.mods=\/home\/gogsaan\/.local\/share\/starsector\/mods/' ./Miko_R3.txt
        sed -i 's/^-Dcom\.fs\.starfarer\.settings\.paths\.logs=.*/-Dcom.fs.starfarer.settings.paths.logs=\/home\/gogsaan\/.local\/share\/starsector\/logs/' ./Miko_R3.txt
      else
        echo "Error: VM parameters file not found."
        exit 1
      fi
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/{bin,share/starsector}
      rm -r jre_linux
      rm starfarer.api.zip
      cp -r ./* $out/share/starsector

      kitsunebi_files="${kitsunebi}/0. Files to put into starsector"
      if [ -d "$kitsunebi_files" ]; then
        cp -rv "$kitsunebi_files"/* $out/share/starsector/
      else
        echo "Error: Kitsunebi directory not found."
        exit 1
      fi

      rm -f $out/share/starsector/Kitsunebi.sh

      mkdir -p $out/share/icons/hicolor/64x64/apps
      ln -s $out/share/starsector/graphics/ui/s_icon64.png \
        $out/share/icons/hicolor/64x64/apps/starsector.png

      # Copy and prepare the launch script
      cp ${launchScript} $out/share/starsector/Kitsunebi.sh
      chmod +x $out/share/starsector/Kitsunebi.sh

      # Install and wrap the launch script
      install -Dm755 $out/share/starsector/Kitsunebi.sh $out/bin/starsector
      wrapProgram $out/bin/starsector \
        --prefix PATH : ${lib.makeBinPath [openjdk23 xorg.xrandr]} \
        --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath buildInputs} \
        --chdir "$out/share/starsector"

      # Update FPS setting in settings.json
      sed -i 's/"fps":60/"fps":120/' $out/share/starsector/data/config/settings.json

      runHook postInstall
    '';

    passthru.updateScript = writeScript "starsector-update-script" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p curl gnugrep common-updater-scripts
      set -eou pipefail;
      version=$(curl -s https://fractalsoftworks.com/preorder/ | \
        grep -oP "https://f005.backblazeb2.com/file/fractalsoftworks/release/starsector_linux-\K.*?(?=\.zip)" | \
        head -1)
      update-source-version ${pname} "$version" --file=./pkgs/games/starsector/default.nix
    '';

    meta = with lib; {
      description = "Open-world single-player space-combat, roleplaying, exploration, and economic game";
      homepage = "https://fractalsoftworks.com";
      sourceProvenance = with sourceTypes; [binaryBytecode];
      license = licenses.unfree;
      maintainers = with maintainers; [bbigras rafaelrc];
    };
  }
