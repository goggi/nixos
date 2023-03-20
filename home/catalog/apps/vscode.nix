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

  # programs.vscode = {
  #   enable = true;
  #   package = (pkgs.vscode.override {isInsiders = true;}).overrideAttrs (oldAttrs: rec {
  #     src = builtins.fetchTarball {
  #       url = "https://code.visualstudio.com/sha/download?build=insider&os=linux-x64";
  #       sha256 = "1l58dd17r7m64sbz3lq6dn7hxlvpazz7fc89mv69mbgvy1w60x54";
  #     };
  #     version = "latest";
  #   });
  # };

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
