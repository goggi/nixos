{
  pkgs ? import <nixpkgs> {system = builtins.currentSystem;},
  lib ? pkgs.lib,
  stdenv ? pkgs.stdenv,
  fetchurl ? pkgs.fetchurl,
  makeWrapper ? pkgs.makeWrapper,
  alsaLib ? pkgs.alsaLib,
  at-spi2-atk ? pkgs.at-spi2-atk,
  atk ? pkgs.atk,
  cairo ? pkgs.cairo,
  cups ? pkgs.cups,
  curl ? pkgs.curl,
  dbus-glib ? pkgs.dbus-glib,
  fontconfig ? pkgs.fontconfig,
  freetype ? pkgs.freetype,
  gdk-pixbuf ? pkgs.gdk-pixbuf,
  glib ? pkgs.glib,
  glibc ? pkgs.glibc,
  gtk2 ? pkgs.gtk2,
  gtk3 ? pkgs.gtk3,
  kerberos ? pkgs.kerberos,
  libX11 ? pkgs.xorg.libX11,
  libXtst ? pkgs.xorg.libXtst,
  libcanberra_gtk2 ? pkgs.libcanberra-gtk2,
  mesa ? pkgs.mesa,
  nspr ? pkgs.nspr,
  nss ? pkgs.nss,
  pango ? pkgs.pango,
  writeScript ? pkgs.writeScript,
  xidel ? pkgs.xidel,
  coreutils ? pkgs.coreutils,
  gnused ? pkgs.gnused,
  gnugrep ? pkgs.gnugrep,
  gnupg ? pkgs.gnupg,
  commandLineArgs ? "",
}:
with lib; let
  wrapArgs = lib.optionalString (commandLineArgs != "") "${commandLineArgs}";
  version = "G6.0.6";

  srcs = {
    "x86_64-linux" = fetchurl {
      url = "https://cdn1.waterfox.net/waterfox/releases/${version}/Linux_x86_64/waterfox-${version}.tar.bz2";
      sha256 = "0csgx5y7ky6azfsk5bmfab99615njs0v2cp0a8082l7dp1nyd9h8";
    };
  };
in
  stdenv.mkDerivation rec {
    name = "waterfox-bin-${version}";
    inherit version;

    src = srcs."${stdenv.system}" or (throw "unsupported system: ${stdenv.system}");

    preferLocalBuild = true;
    allowSubstitutes = false;

    libPath = makeLibraryPath [
      libXtst
      stdenv.cc.cc
      alsaLib
      at-spi2-atk
      atk
      cairo
      cups
      curl
      dbus-glib
      fontconfig
      freetype
      gdk-pixbuf
      glib
      glibc
      gtk2
      gtk3
      kerberos
      libX11
      libcanberra_gtk2
      mesa
      nspr
      nss
      pango
    ];

    nativeBuildInputs = [makeWrapper];

    buildCommand = ''
      mkdir -p "$prefix/opt/waterfox-bin-${version}"
      tar -xf "${src}" -C "$prefix/opt/waterfox-bin-${version}" --strip-components=1
      mkdir -p "$out/bin"
      ln -s "$prefix/opt/waterfox-bin-${version}/waterfox" "$out/bin/"
      for executable in \
        waterfox waterfox-bin plugin-container updater
      do
        patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
          "$prefix/opt/waterfox-bin-${version}/$executable"
      done
      wrapProgram "$out/bin/waterfox" \
        --argv0 "$out/bin/.waterfox-wrapped" \
        --set LD_LIBRARY_PATH "$libPath" \
        --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH:" \
        --suffix XDG_DATA_DIRS : "$XDG_ICON_DIRS"
        ${wrapArgs}
    ''; # kept for override example

    meta = with lib; {
      description = "A web browser (binary package)";
      homepage = "https://www.waterfoxproject.org/";
      license = {
        free = false;
        url = "https://www.waterfoxproject.org/terms";
      };
      maintainers = with lib.maintainers; [iamale];
      platforms = platforms.linux;
    };
  }
