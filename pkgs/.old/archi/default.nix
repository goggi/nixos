{
  lib,
  stdenv,
  fetchurl,
  fetchzip,
  autoPatchelfHook,
  makeWrapper,
  jdk,
  libsecret,
  webkitgtk,
  wrapGAppsHook,
}:
stdenv.mkDerivation rec {
  pname = "Archi";
  version = "5.0.2";

  src =
    if stdenv.hostPlatform.system == "x86_64-linux"
    then
      fetchurl {
        url = "https://www.archimatetool.com/downloads/archi.php?/${version}/Archi-Linux64-${version}.tgz";
        sha256 = "3oamiNXJTsjsHne17QRYRVRsxLauJfo5qoQkzfo7tYY=";
      }
    else if stdenv.hostPlatform.system == "x86_64-darwin"
    then
      fetchzip {
        url = "https://www.archimatetool.com/downloads/archi.php?/${version}/Archi-Mac-${version}.dmg";
        sha256 = "1h05lal5jnjwm30dbqvd6gisgrmf1an8xf34f01gs9pwqvqfvmxc";
      }
    else throw "Unsupported system";

  buildInputs = [
    libsecret
  ];

  nativeBuildInputs =
    [
      makeWrapper
      wrapGAppsHook
    ]
    ++ lib.optional stdenv.hostPlatform.isLinux autoPatchelfHook;

  installPhase =
    if stdenv.hostPlatform.system == "x86_64-linux"
    then ''
      mkdir -p $out/bin $out/libexec
      for f in configuration features p2 plugins Archi.ini; do
        cp -r $f $out/libexec
      done

      install -D -m755 Archi $out/libexec/Archi
      makeWrapper $out/libexec/Archi $out/bin/Archi \
        --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [webkitgtk]} \
        --prefix PATH : ${jdk}/bin
    ''
    else ''
      mkdir -p "$out/Applications"
      mv Archi.app "$out/Applications/"
    '';

  meta = with lib; {
    description = "ArchiMate modelling toolkit";
    longDescription = ''
      Archi is an open source modelling toolkit to create ArchiMate
      models and sketches.
    '';
    homepage = "https://www.archimatetool.com/";
    sourceProvenance = with sourceTypes; [binaryNativeCode];
    license = licenses.mit;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [earldouglas];
  };

  # icon = fetchurl {
  #   url = "https://raw.githubusercontent.com/archimatetool/archi/master/com.archimatetool.editor/img/app-1024.png";
  #   sha256 = "be96194a81e35e2dc5be4e32e8c6d1210bf3d688411871bb2ab93e347bef4613";
  # };

  # desktopItem = makeDesktopItem {
  #   name = "Archimate";
  #   desktopName = "Archimate";
  #   comment = "Knowledge base";
  #   icon = "obsidian";
  #   exec = "Archi %u";
  #   categories = ["Office"];
  #   # mimeTypes = ["x-scheme-handler/obsidian"];
  # };
}
