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

  home = {
    packages = [
      pkgs.cursor
      pkgs.windsurf
    ];
    persistence = {
      "/persist/home/gogsaan" = {
        allowOther = true;
        directories = [
          {
            directory = ".vscode-server";
          }
          {
            directory = ".cursor-server";
          }
          {
            directory = ".config/Code";
            method = "symlink";
          }
          {
            directory = ".config/Cursor";
            method = "symlink";
          }
          {
            directory = ".cursor";
            method = "symlink";
          }
          {
            directory = ".windsurf";
            method = "symlink";
          }
          {
            directory = ".config/Windsurf";
            method = "symlink";
          }
        ];
      };
    };
  };
}
