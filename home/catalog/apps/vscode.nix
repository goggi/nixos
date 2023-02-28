{
  inputs,
  pkgs,
  fetchTarball,
  ...
}: {
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      dracula-theme.theme-dracula
      vscodevim.vim
      yzhang.markdown-all-in-one
    ];
    package = pkgs.vscode.override {
      commandLineArgs = ''
        --enable-features=UseOzonePlatform \
        --ozone-platform=wayland
      '';
    };
  };

  #programs.vscode = {
  # enable = true;
  # package = (pkgs.vscode.override {isInsiders = true;}).overrideAttrs (oldAttrs: rec {
  #   src = builtins.fetchTarball {
  #     url = "https://code.visualstudio.com/sha/download?build=insider&os=linux-x64";
  #     sha256 = "0b38cg59c28ryb9g6vncgcjiiwgxb4d389wc4w8i7g8g94vzavjy";
  #  };
  #   version = "latest";
  # });
  #};

  home.persistence = {
    "/persist/home/gogsaan" = {
      allowOther = true;
      directories = [
        ".config/Code"
        # ".vscode"
      ];
    };
  };
}
