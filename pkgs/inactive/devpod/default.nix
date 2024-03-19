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
in
  buildGoModule {
    inherit version src pname meta;

    vendorSha256 = null;

    CGO_ENABLED = 0;

    ldflags = [
      "-X github.com/loft-sh/devpod/pkg/version.version=v${version}"
    ];

    excludedPackages = ["./e2e"];

    nativeBuildInputs = [installShellFiles];

    postInstall = ''
      $out/bin/devpod completion bash >devpod.bash
      $out/bin/devpod completion fish >devpod.fish
      $out/bin/devpod completion zsh >devpod.zsh
      installShellCompletion devpod.{bash,fish,zsh}
    '';

    passthru.tests.version = testers.testVersion {
      package = pname;
      version = "v${version}";
    };
  }
