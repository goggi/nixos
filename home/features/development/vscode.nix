{
  inputs,
  pkgs,
  fetchTarball,
  ...
}: {
  programs.vscode = {
    enable = true;
    # package = pkgs.vscode.override {
    #   commandLineArgs = ''
    #     --enable-features=UseOzonePlatform \
    #     --ozone-platform=wayland
    #   '';
    # };
    # package = pkgs.vscode.fhs;
    package = pkgs.vscode;
  };

  # programs.vscode = {
  #   enable = true;
  #   package = (pkgs.vscode.override {isInsiders = true;}).overrideAttrs (oldAttrs: rec {
  #     src = builtins.fetchTarball {
  #       url = "https://code.visualstudio.com/sha/download?build=insider&os=linux-x64";
  #       sha256 = "sha256:0alad0hqzasdmlyyd5wdnfr65k2vgd7kw219w5p2ml5xx26ic7w4";
  #     };
  #     version = "latest";
  #   });
  # };

  # home.packages = with pkgs; [
  #   vscode-insiders-with-extensions
  # ];

  home.persistence = {
    "/persist/home/gogsaan" = {
      allowOther = true;
      directories = [
        {
          directory = ".config/Code";
          method = "symlink";
        }
        # ".vscode"
      ];
    };
  };
}
