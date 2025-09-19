{ inputs, pkgs, fetchTarball, ... }: {
  programs.vscode = {
    enable = true;
    #   package = (pkgs.vscode.override { isInsiders = true; }).overrideAttrs (oldAttrs: rec {
    #     src = (builtins.fetchTarball {
    #       url = "https://code.visualstudio.com/sha/download?build=insider&os=linux-x64";
    #       sha256 = "sha256:1y6lp9l079n76ycsizzy1r62s6766z4k32bp125p6srmclmg7xiq";
    #     });
    #     version = "latest";

    #     buildInputs = oldAttrs.buildInputs ++ [ pkgs.krb5 ];
    #   });
  };

  # programs.vscode = {
  #   enable = true;
  #   package = pkgs.vscodium;
  # };

  home = {
    packages = [
      pkgs.cursor
      pkgs.windsurf
      pkgs.biome
      pkgs.kiro
      # pkgs.claude-desktop
      # pkgs.claude-code
    ];
    persistence = {
      "/persist/home/gogsaan" = {
        allowOther = true;
        directories = [
          { directory = ".vscode-server"; }
          { directory = ".cursor-server"; }
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
            directory = ".kiro";
            method = "symlink";
          } 
          {
            directory = ".config/Kiro";
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
          {
            directory = ".config/VSCodium";
            method = "symlink";
          }
          {
            directory = ".config/Code - Insiders";
            method = "symlink";
          }
          {
            directory = ".codeium";
            method = "symlink";
          }
          {
            directory = ".claude";
            method = "symlink";
          }
          {
            directory = ".serena";
            method = "symlink";
          }

        ];
        files = [ ".claude.json" ".bash_history" ];
      };
    };
  };

  xdg.desktopEntries.kiro = {
    name = "Kiro Wayland";
    exec = "kiro --enable-features=UseOzonePlatform --ozone-platform=wayland";
  };
}
