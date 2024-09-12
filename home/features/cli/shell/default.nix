{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  browser = ["firefox.desktop"];
  associations = {
    "application/x-extension-htm" = browser;
    "application/x-extension-html" = browser;
    "application/x-extension-shtml" = browser;
    "application/x-extension-xht" = browser;
    "application/x-extension-xhtml" = browser;
    "application/x-yaml" = ["lapce.desktop"];
    "application/xml" = ["lapce.desktop"];
    "x-scheme-handler/about" = browser;
    "x-scheme-handler/chrome" = ["chromium-browser.desktop"];
    "x-scheme-handler/ftp" = browser;
    "x-scheme-handler/http" = browser;
    "x-scheme-handler/https" = browser;
    "x-scheme-handler/unknown" = browser;
    "text/plain" = ["lapce.desktop"];
    "audio/*" = ["mpv.desktop"];
    "video/*" = ["mpv.dekstop"];
    "application/json" = ["lapce.desktop"];
    "application/pdf" = ["org.pwmt.zathura.desktop.desktop"];
    "x-scheme-handler/discord" = ["discordcanary.desktop"];
    "x-scheme-handler/spotify" = ["spotify.desktop"];
    "x-scheme-handler/tg" = ["telegramdesktop.desktop"];
    "image/*" = ["imv-folder.desktop"];
  };
in {
  imports = [
    ./cli.nix
    ./git.nix
    ./nix.nix
    ./starship.nix
    ./transient-services.nix
  ];

  home = {
    sessionPath = [
      "${config.home.homeDirectory}/.local/bin"
    ];

    file = {
      ".local/bin/updoot" = {
        # Upload and get link
        executable = true;
        text = import ./bin/updoot.nix {inherit pkgs;};
      };

      ".local/bin/preview.sh" = {
        # Preview script for fzf tab
        executable = true;
        text = import ./bin/preview.nix {inherit pkgs;};
      };
    };
  };

  services = {
    syncthing.enable = true;
  };

  programs = {
    ssh = {
      enable = true;
      extraConfig = ''
        # Host *
        #   AddKeysToAgent yes
        #   UseKeychain yes
        #   IdentityFile ~/.ssh/id_rsa

        Host *
          IdentityAgent ~/.1password/agent.sock
      '';
    };

    gpg = {
      enable = true;
      homedir = "${config.home.homeDirectory}/.gnupg";
    };
  };

  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
      extraConfig = {
        XDG_DEVELOPMENT_DIR = "${config.xdg.userDirs.documents}/Dev";
      };
    };

    # mimeApps = {
    #   enable = true;
    #   associations.added = associations;
    #   defaultApplications = associations;
    # };
  };
}
