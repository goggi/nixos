{
  description = "VSCode Wayland debugging";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    nixpkgs_electron_19_1_9.url = "github:NixOS/nixpkgs/75a52265bda7fd25e06e3a67dee3f0354e73243c";
    nixpkgs_electron_20_3_12.url = "github:NixOS/nixpkgs/75a52265bda7fd25e06e3a67dee3f0354e73243c";
    nixpkgs_electron_21_4_4.url = "github:NixOS/nixpkgs/75a52265bda7fd25e06e3a67dee3f0354e73243c";
    nixpkgs_electron_22_0_0.url = "github:NixOS/nixpkgs/2d38b664b4400335086a713a0036aafaa002c003";
  };

  outputs = inputs: let
    electronVersionData = [
      {
        version = "19.1.9";
        nixpkgsRevision = "75a52265bda7fd25e06e3a67dee3f0354e73243c";
      }
      {
        version = "20.3.12";
        nixpkgsRevision = "75a52265bda7fd25e06e3a67dee3f0354e73243c";
      }
      {
        version = "21.4.4";
        nixpkgsRevision = "75a52265bda7fd25e06e3a67dee3f0354e73243c";
      }
      {
        version = "22.0.0";
        nixpkgsRevision = "2d38b664b4400335086a713a0036aafaa002c003";
      }
    ];
    versionId = version: builtins.replaceStrings ["."] ["_"] version;
    electronNixpkgs = versionData: "nixpkgs_electron_${(versionId versionData.version)}";
    nixpkgs = inputs.nixpkgs;
    lib = nixpkgs.lib;
    pkgs = nixpkgs.legacyPackages.x86_64-linux;
    electronPkgName = versionData: "electron_${builtins.head (lib.strings.splitString "." versionData.version)}";
    electronVersions = builtins.listToAttrs (map
      (versionData:
        lib.nameValuePair
        (versionId versionData.version)
        inputs."${electronNixpkgs versionData}".legacyPackages.x86_64-linux."${electronPkgName versionData}")
      electronVersionData);
    electronAtVersion = versionData: electronVersions."${versionId versionData.version}";
    vscodeVersionData = [
      {
        version = "1.77.3";
        sha256 = "0sf8kkhvz73b8q7dxy53vikgpksgdffzj9qbkd9mbx6qjv0k60yw";
      }
      {
        version = "1.78.0";
        sha256 = "sha256-GmWKqjRe2fQKNcN4xJYF9w+z5k/pTCtfjhsDza59K4Y=";
      }
    ];
    vscodeAtVersion = {
      version,
      sha256,
    }: (pkgs.vscode.overrideAttrs (finalAttrs: previousAttrs: {
      version = version;
      src = pkgs.fetchurl {
        name = "VSCode_${version}_linux-x64.tar.gz";
        url = "https://update.code.visualstudio.com/${version}/linux-x64/stable";
        inherit sha256;
      };
      installPhase =
        (previousAttrs.installPhase or "")
        + ''
          chmod +x $out/lib/vscode/resources/app/node_modules/node-pty/build/Release/spawn-helper || echo "ignore"
          chmod +x $out/lib/vscode/resources/app/node_modules.asar.unpacked/node-pty/build/Release/spawn-helper || echo "ignore"
        '';
    }));
    vscodeHybridVersion = mainPackage: transplantPackage: (mainPackage.overrideAttrs (finalAttrs: previousAttrs: {
      installPhase =
        (previousAttrs.installPhase or "")
        + ''
          rm -fr $out/lib/vscode/resources
          cp -r ${transplantPackage}/lib/vscode/resources $out/lib/vscode/resources
        '';
    }));
    anonymize = vscode: (pkgs.writers.writeBashBin "tmp-code" ''
      set -e
      if ! [ $UNSHARED ]; then
        UNSHARED=1 exec unshare -rm "$0" "''${@}"
      fi
      MNT="/run/current-system/sw/bin/mount"
      TMPDATA="$(mktemp -d -t tmpcodeXXXXXX)"
      "$MNT" -t tmpfs tmpfs "$TMPDATA"
      unshare -U -- ${vscode}/bin/code -n --no-sandbox --user-data-dir "$TMPDATA" --ozone-platform-hint=auto "''${@}"
    '');
    electronWrapper = vscode: electron: (pkgs.writers.writeBashBin "electron-code" ''
      set -e
      if ! [ $UNSHARED ]; then
        UNSHARED=1 exec unshare -rm "$0" "''${@}"
      fi
      MNT="/run/current-system/sw/bin/mount"
      TMPDATA="$(mktemp -d -t tmpcodeXXXXXX)"
      "$MNT" -t tmpfs tmpfs "$TMPDATA"
      unshare -U -- ${electron}/bin/electron "${vscode}/lib/vscode/resources/app" -n --no-sandbox --user-data-dir "$TMPDATA" --ozone-platform-hint=auto "''${@}"
    '');
    vscodePackages =
      builtins.listToAttrs
      (map
        (
          versionData:
            lib.nameValuePair
            "vscode_${versionId versionData.version}"
            (vscodeAtVersion versionData)
        )
        vscodeVersionData);
    vscodeElectronWrapped =
      builtins.listToAttrs
      (map
        (
          {
            vscode,
            electron,
          }:
            lib.nameValuePair
            "vscode_${versionId vscode.version}_in_electron_${versionId electron.version}"
            (electronWrapper (vscodeAtVersion vscode) (electronAtVersion electron))
        )
        (lib.lists.crossLists (vscode: electron: {inherit vscode electron;}) [vscodeVersionData electronVersionData]));
  in {
  };
}
