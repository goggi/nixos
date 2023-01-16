{
  inputs,
  pkgs,
  fetchTarball,
  ...
}: {
  programs.vscode = {
    enable = true;
    package = pkgs.vscode.override {
      commandLineArgs = ''
        --enable-features=UseOzonePlatform \
        --ozone-platform=wayland
      '';
    };
  };

  home.persistence = {
    "/persist/home/gogsaan" = {
      allowOther = true;
      directories = [
        ".config/Code"
        ".vscode"
      ];
    };
  };
}
