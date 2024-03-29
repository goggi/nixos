{
  lib,
  buildGoModule,
  copyDesktopItems,
  darwin,
  desktopToDarwinBundle,
  fetchFromGitHub,
  fetchYarnDeps,
  gtk3,
  installShellFiles,
  jq,
  libayatana-appindicator,
  libsoup,
  makeDesktopItem,
  mkYarnPackage,
  openssl,
  pkg-config,
  rust,
  rustPlatform,
  stdenv,
  testers,
  webkitgtk,
  devpod,
}: let
  pname = "devpod";
  version = "0.3.7";

  src = fetchFromGitHub {
    owner = "loft-sh";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-s5O7pcrynfwgye6NdcF6XOCRDf1VS9i8Z3ghOQnjiKg=";
  };

  meta = with lib; {
    description = "Codespaces but open-source, client-only and unopinionated: Works with any IDE and lets you use any cloud, kubernetes or just localhost docker. ";
    homepage = "https://devpod.sh";
    license = licenses.mpl20;
    maintainers = with maintainers; [maxbrunet];
  };
in let
  frontend-build = mkYarnPackage {
    inherit version;
    pname = "devpod-frontend";

    src = "${src}/desktop";

    offlineCache = fetchYarnDeps {
      yarnLock = "${src}/desktop/yarn.lock";
      sha256 =
        {
          stdenv-linux = "sha256-O/w7g+kNgWrzP7EZ4Dgzea81c8hsqR9MQ8Fgmp7IwlE=";
          stdenv-darwin = "sha256-z1dPaS5g6xlzKEJzPkpeShB+dTJHgQbzjQ9Rq3o+Xjo=";
        }
        ."${stdenv.name}";
    };

    buildPhase = ''
      export HOME=$(mktemp -d)
      yarn --offline run build

      cp -r deps/devpod/dist $out
    '';

    distPhase = "true";
    dontInstall = true;
  };

  rustTargetPlatformSpec = rust.toRustTargetSpec stdenv.hostPlatform;
in
  rustPlatform.buildRustPackage {
    inherit version src;
    pname = "devpod-desktop";

    sourceRoot = "${src.name}/desktop/src-tauri";

    cargoLock = {
      lockFile = "${src}/desktop/src-tauri/Cargo.lock";
      outputHashes = {
        "tauri-plugin-log-0.1.0" = "sha256-Ei0j7UNzsK45c8fEV8Yw3pyf4oSG5EYgLB4BRfafq6A=";
      };
    };

    # Workaround:
    #   The `tauri` dependency features on the `Cargo.toml` file does not match the allowlist defined under `tauri.conf.json`.
    #   Please run `tauri dev` or `tauri build` or add the `updater` feature.
    patches = [./add-tauri-updater-feature.patch];

    postPatch =
      ''
        ln -s ${devpod}/bin/devpod bin/devpod-cli-${rustTargetPlatformSpec}
        cp -r ${frontend-build} frontend-build

        substituteInPlace tauri.conf.json --replace '"distDir": "../dist",' '"distDir": "frontend-build",'
      ''
      + lib.optionalString stdenv.isLinux ''
        substituteInPlace $cargoDepsCopy/libappindicator-sys-*/src/lib.rs \
          --replace "libayatana-appindicator3.so.1" "${libayatana-appindicator}/lib/libayatana-appindicator3.so.1"

        # Since `cargo build` is used instead of `tauri build`, configs are merged manually.
        jq --slurp '.[0] * .[1]' tauri.conf.json tauri-linux.conf.json >tauri.conf.json.merged
        mv tauri.conf.json.merged tauri.conf.json
      '';

    nativeBuildInputs =
      [
        copyDesktopItems
        pkg-config
      ]
      ++ lib.optionals stdenv.isLinux [
        jq
      ]
      ++ lib.optionals stdenv.isDarwin [
        desktopToDarwinBundle
      ];

    buildInputs =
      [
        libsoup
        openssl
      ]
      ++ lib.optionals stdenv.isLinux [
        gtk3
        libayatana-appindicator
        webkitgtk
      ]
      ++ lib.optionals stdenv.isDarwin [
        darwin.apple_sdk.frameworks.Carbon
        darwin.apple_sdk.frameworks.Cocoa
        darwin.apple_sdk.frameworks.WebKit
      ];

    desktopItems = [
      (makeDesktopItem {
        name = "DevPod";
        categories = ["Development"];
        comment = "Spin up dev environments in any infra";
        desktopName = "DevPod";
        exec = "DevPod %U";
        icon = "DevPod";
        terminal = false;
        type = "Application";
        mimeTypes = ["x-scheme-handler/devpod"];
      })
    ];

    postInstall = ''
      ln -sf ${devpod}/bin/devpod $out/bin/devpod-cli
      mv $out/bin/devpod-desktop $out/bin/DevPod

      mkdir -p $out/share/icons/hicolor/{256x256@2,128x128,32x32}/apps
      cp icons/128x128@2x.png $out/share/icons/hicolor/256x256@2/apps/DevPod.png
      cp icons/128x128.png $out/share/icons/hicolor/128x128/apps/DevPod.png
      cp icons/32x32.png $out/share/icons/hicolor/32x32/apps/DevPod.png
    '';

    meta =
      meta
      // {
        mainProgram = "DevPod";
        # darwin does not build
        # https://github.com/h4llow3En/mac-notification-sys/issues/28
        platforms = lib.platforms.linux;
      };
  }
