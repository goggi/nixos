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
    package = pkgs.vscode.fhs;
  };

  # programs.vscode = {
  #   enable = true;
  #   package = (pkgs.vscode.override {isInsiders = true;}).overrideAttrs (oldAttrs: rec {
  #     src = builtins.fetchTarball {
  #       url = "https://code.visualstudio.com/sha/download?build=insider&os=linux-x64";
  #       sha256 = "sha256:14hlmq519qb3zadrdvxv52irdrak4gl6rg8ki25fd1dvbzc75jnc";
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
        ".config/Code"
        # ".vscode"
      ];
    };
  };
}
