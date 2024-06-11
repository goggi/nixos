{
  lib,
  stdenv,
  fetchurl,
  makeDesktopItem,
  copyDesktopItems,
  makeWrapper,
  writeText,
  wrapGAppsHook,
  autoPatchelfHook,
  callPackage,
  atk,
  cairo,
  dbus,
  dbus-glib,
  fontconfig,
  freetype,
  gdk-pixbuf,
  glib,
  gtk3,
  libxcb,
  libX11,
  libXext,
  libXrender,
  libXt,
  libXtst,
  libu2f-host,
  udev,
  mesa,
  pango,
  pciutils,
  zlib,
  libnotifySupport ? stdenv.isLinux,
  libnotify,
  waylandSupport ? stdenv.isLinux,
  libxkbcommon,
  libdrm,
  libGL,
  mediaSupport ? true,
  ffmpeg,
  audioSupport ? mediaSupport,
  pipewireSupport ? audioSupport,
  pipewire,
  pulseaudioSupport ? audioSupport,
  libpulseaudio,
  apulse,
  alsa-lib,
  libvaSupport ? mediaSupport,
  libva,
  # Extra preferences
  extraPrefs ? "",
}: let
  libPath = lib.makeLibraryPath (
    [
      alsa-lib
      atk
      cairo
      dbus
      dbus-glib
      fontconfig
      freetype
      gdk-pixbuf
      glib
      gtk3
      libxcb
      libX11
      libXext
      libXrender
      libXt
      libXtst
      libu2f-host
      udev
      mesa
      pango
      pciutils
      stdenv.cc.cc
      stdenv.cc.libc
      zlib
    ]
    ++ lib.optionals libnotifySupport [libnotify]
    ++ lib.optionals waylandSupport [libxkbcommon libdrm libGL]
    ++ lib.optionals pipewireSupport [pipewire]
    ++ lib.optionals pulseaudioSupport [libpulseaudio]
    ++ lib.optionals libvaSupport [libva]
    ++ lib.optionals mediaSupport [ffmpeg]
  );

  version = "11.13.3";

  sources = {
    "x86_64-linux" = fetchurl {
      url = "https://github.com/Floorp-Projects/Floorp/releases/download/v${version}/floorp-${version}.linux-x86_64.tar.bz2";
      sha256 = "JCBKRyt/ZotxuushlI0DfTS1a8JbXCOA429QRrwr6Bs=";
    };
  };

  # distributionIni = writeText "distribution.ini" (lib.generators.toINI {} {
  #   # Some light branding indicating this build uses our distro preferences
  #   Global = {
  #     id = "nixos";
  #     version = "1.0";
  #     about = "Mullvad Browser for NixOS";
  #   };
  # });

  policiesJson = writeText "policies.json" (builtins.toJSON {
    policies.DisableAppUpdate = true;
  });
in
  stdenv.mkDerivation rec {
    pname = "floorp-browser-${version}";
    inherit version;

    src = sources.${stdenv.hostPlatform.system} or (throw "unsupported system: ${stdenv.hostPlatform.system}");

    nativeBuildInputs = [copyDesktopItems makeWrapper wrapGAppsHook autoPatchelfHook];
    buildInputs = [
      gtk3
      alsa-lib
      dbus-glib
      libXtst
    ];

    preferLocalBuild = true;
    allowSubstitutes = false;

    desktopItems = [
      (makeDesktopItem {
        name = "floorpbrowser";
        exec = "floorp-browser %U";
        icon = "floorp-browser";
        desktopName = "floorp";
        genericName = "Web Browser";
        comment = meta.description;
        categories = ["Network" "WebBrowser" "Security"];
      })
    ];

    buildPhase = ''
      runHook preBuild

      # For convenience ........
      MB_IN_STORE=$out/share/floorp-browser

      # Unpack & enter
      mkdir -p "$MB_IN_STORE"
      tar xf "$src" -C "$MB_IN_STORE" --strip-components=1
      pushd "$MB_IN_STORE"

      for executable in \
        floorp floorp-bin plugin-container updater
      do
        patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
          "$MB_IN_STORE/$executable"
      done

      # Add bundled libraries to libPath.
      libPath=${libPath}:$MB_IN_STORE

      # apulse uses a non-standard library path.  For now special-case it.
      ${lib.optionalString (audioSupport && !pulseaudioSupport) ''
        libPath=${apulse}/lib/apulse:$libPath
      ''}

      mkdir -p $out/bin

      makeWrapper "$MB_IN_STORE/floorp" "$out/bin/floorp-browser" \
        --prefix LD_LIBRARY_PATH : "$libPath" \
        --set-default MOZ_ENABLE_WAYLAND 1 \
        --set MOZ_LEGACY_PROFILES 1

      # Install icons
      for i in 16 32 48 64 128; do
        mkdir -p $out/share/icons/hicolor/''${i}x''${i}/apps/
        ln -s $out/share/floorp-browser/browser/chrome/icons/default/default$i.png $out/share/icons/hicolor/''${i}x''${i}/apps/floorp-browser.png
      done

      # Check installed appss
      echo "Checking floorp-browser wrapper ..."
      $out/bin/floorp-browser --version >/dev/null

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      #   # Install distribution customizations
        install -Dvm644 ${policiesJson} $out/share/floorp-browser/distribution/policies.json
      runHook postInstall
    '';

    passthru = {
      updateScript = callPackage ./update.nix {
        attrPath = "floorp-unwrapped";
      };
      libName = "floorp-bin-${version}";
      ffmpegSupport = true;
      gssSupport = true;
      gtk3 = gtk3;
    };

    meta = with lib; {
      description = "A fork of Firefox, focused on keeping the Open, Private and Sustainable Web alive, built in Japan";
      homepage = "https://floorp.app/";
      maintainers = with lib.maintainers; [christoph-heiss];
      platforms = lib.platforms.unix;
      badPlatforms = lib.platforms.darwin;
      broken = stdenv.buildPlatform.is32bit; # since Firefox 60, build on 32-bit platforms fails with "out of memory".
      # not in `badPlatforms` because cross-compilation on 64-bit machine might work.
      maxSilent = 14400; # 4h, double the default of 7200s (c.f. #129212, #129115)
      license = lib.licenses.mpl20;
    };
  }
