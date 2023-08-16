{
  config,
  inputs,
  pkgs,
  pkgsUnstable,
  lib,
  system,
  ...
}: {
  imports = [
    # Core
    inputs.impermanence.nixosModules.home-manager.impermanence
    ../features/core.nix

    # Desktops
    ../features/desktop/hyprland
    # ../features/desktop/sway

    # Browser
    ../features/browser/firefox
    ../features/browser/googleChrome.nix
    # ../features/browser/vivaldi.nix
    # ../features/browser/chromium.nix

    # Development
    ../features/development/vscode.nix
    ../features/development/navicatPersistance.nix
    ../features/development/dockerPersistance.nix
    ../features/development/k8sManagment.nix
    # ../features/development/jetbrain.nix
    # ../features/development/helix

    ../features/development/language/nodejs.nix
    ../features/development/language/python3.nix

    # Management
    ../features/management/1password.nix
    ../features/management/keepassxc.nix
    ../features/management/yubikey.nix
    ../features/management/gpg.nix

    # Document
    ../features/document/obsidian.nix
    ../features/document/zathura.nix
    ../features/document/lapce.nix

    # Communication
    ../features/communcation/signalDesktop.nix
    ../features/communcation/webcord.nix

    # Media
    ../features/media/obsStudio.nix

    # Work
    ../features/work/teams.nix

    # Cli
    ../features/cli/fish.nix
    ../features/cli/kitty.nix
    ../features/cli/shell
    ../features/cli/foot.nix

    # Tool
    ../features/tool/flatpakPersistance.nix
    ../features/tool/btop.nix
    ../features/tool/nemo.nix
    # ../features/tool/idasen.nix
    ../features/tool/nomacs.nix
    ../features/tool/swappy.nix

    # Game
    ../features/game/steam.nix
    ../features/game/lutris.nix
    # ../features/game/bottles.nix
    ../features/game/minecraft.nix
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
          # "Projects"
          {
            directory = "Projects";
            method = "symlink";
          }
          ".config/certs"
          ".config/dconf"
          ".config/vpn"
          ".config/sops"
          ".ssh"
          ".aws"
          ".local/share/applications"
          # ".local/share/waydroid"
          ".local/share/desktop-directories"
        ];
        files = [
          ".zsh_history"
          # ".config/mimeapps.list"
        ];
        allowOther = true;
      };
    };
  };

  # disable manuals as nmd fails to build often
  manual = {
    html.enable = false;
    json.enable = false;
    manpages.enable = false;
  };

  # let HM manage itself when in standalone mode
  programs.home-manager.enable = true;

  programs.mangohud = {
    enable = true;
    # enableSessionWide = true;
  };
}
