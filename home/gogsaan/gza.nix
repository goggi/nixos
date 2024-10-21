{
  config,
  inputs,
  pkgs,
  lib,
  system,
  ...
}: {
  imports = [
    # Core
    inputs.catppuccin.homeManagerModules.catppuccin
    inputs.impermanence.nixosModules.home-manager.impermanence
    ../features/core.nix

    # Desktops
    ../features/desktop/hyprland
    # ../features/desktop/sway

    # Browser
    # ../features/browser/firefox
    ../features/browser/googleChrome.nix
    # ../features/browser/thorium.nix

    # ../features/browser/floorp.nix
    ../features/browser/vivaldi.nix
    # ../features/browser/chromium.nix
    # ../features/browser/librewolf
    # ../features/browser/brave.nix
    # ../features/browser/waterfox.nix
    # ../features/browser/wavebox.nix
    ../features/browser/microsoftEdgeDev.nix
    # ../features/browser/microsoftEdge.nix

    # Development
    ../features/development/vscode.nix
    "${fetchTarball {
      url = "https://github.com/msteen/nixos-vscode-server/tarball/master";
      sha256 = "09j4kvsxw1d5dvnhbsgih0icbrxqv90nzf0b589rb5z6gnzwjnqf";
    }}/modules/vscode-server/home.nix"

    "${fetchTarball {
      url = "https://github.com/warmingking/nixos-cursor-server/tarball/master";
      sha256 = "sha256:1yr2613zjam8cjhswin3sqaz69jba9bwc03bi596p73mc7nb8lys";
    }}/modules/cursor-server/home.nix"

    # "${fetchTarball "https://github.com/msteen/nixos-vscode-server/tarball/master"}/modules/vscode-server/home.nix"
    ../features/development/navicatPersistance.nix
    ../features/development/dockerPersistance.nix
    ../features/development/k8sManagment.nix
    ../features/development/archi.nix

    # ../features/development/jetbrain.nix
    # ../features/development/helix
    ../features/development/language/nodejs.nix
    ../features/development/language/python3.nix
    ../features/development/language/gleam.nix
    # inputs.nix-doom-emacs.hmModule

    # Management
    ../features/management/1password.nix
    ../features/management/gnomeKeyring.nix
    # ../features/management/keepassxc.nix
    ../features/management/yubikey.nix
    ../features/management/gpg.nix

    # Document
    ../features/document/obsidian.nix
    ../features/document/logseq.nix
    ../features/document/zathura.nix
    ../features/document/lapce.nix

    # Communication
    ../features/communcation/signalDesktop.nix
    # ../features/communcation/webcord.nix
    ../features/communcation/vencord.nix

    # Media
    ../features/media/obsStudio.nix
    ../features/media/plex.nix

    # Cli
    ../features/cli/fish.nix
    ../features/cli/kitty.nix
    ../features/cli/shell
    ../features/cli/foot.nix

    # Tool
    ../features/tool/flatpakPersistance.nix
    ../features/tool/btop.nix
    ../features/tool/nemo.nix
    ../features/tool/idasen.nix
    ../features/tool/swappy.nix
    ../features/tool/wasabiwallet.nix
    ../features/tool/wayvnc.nix

    # Game
    ../features/game/steam.nix
    ../features/game/lutris.nix
    ../features/game/minecraft.nix
    ../features/game/starsector.nix
    # ../features/game/bottles.nix
  ];

  home = {
    username = "gogsaan";
    homeDirectory = "/home/gogsaan";
    stateVersion = "23.11";
    extraOutputsToInstall = ["doc" "devdoc"];
    # Seems like it needs to be commented out on first boot,ss
    persistence = {
      "/persist/home/gogsaan" = {
        directories = [
          "Documents"
          "Applications"
          "Downloads"
          "Pictures"
          "Videos"
          "Audio"
          # "Projects"
          {
            directory = "Projects";
            method = "symlink";
          }
          ".cache/hyprland"
          ".config/certs"
          ".config/dconf"
          ".config/vpn"
          ".config/sops"
          ".config/rclone"
          ".ssh"
          ".aws"
          ".local/share/applications"
          # ".local/share/waydroid"
          ".local/share/desktop-directories"
        ];
        files = [
          ".zsh_history"
          ".config/mimeapps.list"
        ];
        allowOther = true;
      };
    };
  };

  services.vscode-server.enable = true;
  services.cursor-server.enable = true;
  # services.vscode-server.nodejsPackage = pkgs.nodejs-16_x;
  # disable manuals as nmd fails to build often
  manual = {
    html.enable = false;
    json.enable = false;
    manpages.enable = false;
  };

  # let HM manage itself when in standalone mode
  programs.home-manager.enable = true;

  # programs.doom-emacs = {
  #   enable = true;
  #   doomPrivateDir = ./doom.d; # Directory containing your config.el, init.el
  #   # and packages.el files
  # };

  programs.mangohud = {
    enable = true;
    enableSessionWide = false;
  };
}
