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

  version = "G6.0.6";

  sources = {
    "x86_64-linux" = fetchurl {
      url = "https://cdn1.waterfox.net/waterfox/releases/${version}/Linux_x86_64/waterfox-${version}.tar.bz2";
      sha256 = "0csgx5y7ky6azfsk5bmfab99615njs0v2cp0a8082l7dp1nyd9h8";
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
    pname = "waterfox-browser-${version}";
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
        name = "waterfoxbrowser";
        exec = "waterfox-browser %U";
        icon = "waterfox-browser";
        desktopName = "Waterfox";
        genericName = "Web Browser";
        comment = meta.description;
        categories = ["Network" "WebBrowser" "Security"];
      })
    ];

    buildPhase = ''
      runHook preBuild

      # For convenience ........
      MB_IN_STORE=$out/share/waterfox-browser

      # Unpack & enter
      mkdir -p "$MB_IN_STORE"
      tar xf "$src" -C "$MB_IN_STORE" --strip-components=1
      pushd "$MB_IN_STORE"

      for executable in \
        waterfox waterfox-bin plugin-container updater
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

      makeWrapper "$MB_IN_STORE/waterfox" "$out/bin/waterfox-browser" \
        --prefix LD_LIBRARY_PATH : "$libPath" \
        --set-default MOZ_ENABLE_WAYLAND 1 \
        --set MOZ_LEGACY_PROFILES 1

      # Install icons
      for i in 16 32 48 64 128; do
        mkdir -p $out/share/icons/hicolor/''${i}x''${i}/apps/
        ln -s $out/share/waterfox-browser/browser/chrome/icons/default/default$i.png $out/share/icons/hicolor/''${i}x''${i}/apps/waterfox-browser.png
      done

      # Check installed appss
      echo "Checking waterfox-browser wrapper ..."
      $out/bin/waterfox-browser --version >/dev/null

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      #   # Install distribution customizations
        install -Dvm644 ${policiesJson} $out/share/waterfox-browser/distribution/policies.json
      runHook postInstall
    '';

    passthru = {
      updateScript = callPackage ./update.nix {
        attrPath = "librewolf-unwrapped";
      };
      libName = "waterfox-bin-${version}";
      ffmpegSupport = true;
      gssSupport = true;
      gtk3 = gtk3;
    };

    meta = with lib; {
      description = "A web browser (binary package)";
      homepage = "https://www.waterfoxproject.org/";
      license = {
        free = false;
        url = "https://www.waterfoxproject.org/terms";
      };
      maintainers = with lib.maintainers; [goggi];
      platforms = platforms.linux;
    };
  }
