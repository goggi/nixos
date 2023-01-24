{
  config,
  inputs,
  pkgs,
  lib,
  system,
  ...
}: {
  imports = [
    inputs.impermanence.nixosModules.home-manager.impermanence

    # Apps
    ../catalog/apps/core.nix
    ../catalog/apps/k8sManagment.nix
    ../catalog/apps/obsStudio.nix
    ../catalog/apps/kitty.nix

    # Development
    ../catalog/dev/nodejs.nix
    ../catalog/dev/python3.nix

    # Desktops
    ../catalog/desktops/hyprland

    # Features
    ../catalog/features/shell

    # Persistance
    # App with persistance
    # ../catalog/apps/vscodeInsiders.nix
    # ../catalog/apps/googleChrome.nix
    # ../catalog/apps/neovim.nix

    ../catalog/apps/googleChromeBeta.nix
    ../catalog/apps/vscode.nix
    ../catalog/apps/1password.nix
    ../catalog/apps/obsidian.nix
    ../catalog/apps/signalDesktop.nix
    ../catalog/apps/firefox
    ../catalog/apps/webcord.nix
    ../catalog/apps/fish.nix
    ../catalog/apps/navicat.nix
    ../catalog/apps/btop.nix
    ../catalog/apps/coder.nix

    # Games with persistance
    ../catalog/apps/steam.nix

    # Features with persistance
    ../catalog/features/yubikey.nix
    ../catalog/features/gpg.nix
  ];

  home = {
    username = "gogsaan";
    homeDirectory = "/home/gogsaan";
    stateVersion = "22.11";
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
          "Projects"
          ".config/certs"
          ".config/vpn"
          ".config/sops"
          ".ssh"
          ".aws"
          ".local/share/keyrings"
          ".local/share/applications"
          ".local/share/desktop-directories"
        ];
        files = [
          ".zsh_history"
        ];
        allowOther = true;
      };
    };
  };

  #Add support for ./local/bin
  # home.sessionPath = [
  #   "$HOME/.local/bin"
  # ];

  # disable manuals as nmd fails to build often
  manual = {
    html.enable = false;
    json.enable = false;
    manpages.enable = false;
  };

  # let HM manage itself when in standalone mode
  programs.home-manager.enable = true;
}
