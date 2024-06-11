# This file (and the global directory) holds config that i use on all hosts
{
  lib,
  pkgs,
  self,
  inputs,
  ...
}: {
  imports = [
    ./sops.nix
    ./ssh.nix
    ./yubikey.nix
    ./fonts.nix
    ./locale.nix
    ./network.nix
    ./nix.nix
  ];

  console = {
    earlySetup = false;
    packages = with pkgs; [terminus_font];
    font = "${pkgs.terminus_font}/share/consolefonts/ter-u28n.psf.gz";
    # font = "ter-powerline-v24b";
    # packages = [
    #   pkgs.terminus_font
    #   pkgs.powerline-fonts
    # ];
    keyMap = "us";
  };

  security = {
    rtkit.enable = true;
    polkit.enable = true;
    pam.services.swaylock = {
      text = ''
        auth include login
      '';
    };

    apparmor = {
      enable = true;
      killUnconfinedConfinables = true;
      packages = [pkgs.apparmor-profiles];
    };

    pam = {
      loginLimits = [
        {
          domain = "@wheel";
          item = "nofile";
          type = "soft";
          value = "524288";
        }
        {
          domain = "@wheel";
          item = "nofile";
          type = "hard";
          value = "1048576";
        }
      ];
    };
  };

  services = {
    blueman.enable = true;
    fwupd.enable = true;
    gvfs.enable = true;
    lorri.enable = true;
    udisks2.enable = true;
    printing.enable = true;
    fstrim.enable = true;
    btrfs.autoScrub.enable = true;
    acpid.enable = true;
    thermald.enable = true;
    upower.enable = true;

    # Xserver & Xwayland
    xserver.enable = false;
    xserver.autorun = true;

    udev.packages = with pkgs; [gnome.gnome-settings-daemon];

    dbus = {
      enable = true;
      packages = with pkgs; [dconf gcr];
    };

    logind = {
      lidSwitch = "suspend-then-hibernate";
      lidSwitchExternalPower = "lock";
      extraConfig = ''
        HandlePowerKey=ignore
        HibernateDelaySec=3600
      '';
    };
  };

  programs = {
    # bash.promptInit = ''eval "$(${pkgs.starship}/bin/starship init bash)"'';
    # fish.promptInit = ''eval "$(${pkgs.starship}/bin/starship init fish | source)"'';
    xwayland.enable = true;
    gnome-disks.enable = true;
    adb.enable = true;
    dconf.enable = true;
    nm-applet.enable = true;
    seahorse.enable = true;
    fuse.userAllowOther = true;

    npm = {
      enable = true;
      npmrc = ''
        prefix = ''${HOME}/.npm
        color = true
      '';
    };

    java = {
      enable = true;
      package = pkgs.jre;
    };
  };

  environment = {
    binsh = "${pkgs.bash}/bin/bash";
    shells = with pkgs; [fish];

    systemPackages = with pkgs; [
      gnumake
      devenv
      rclone
      s3fs
      inputs.bazecor.packages.${pkgs.system}.default
      acpi
      libva-utils
      ocl-icd
      qt6.qtwayland
      inputs.lug.packages.${pkgs.system}.lug-helper # installs a package
      wineWowPackages.stable
      wineWowPackages.waylandFull
      curl
      gcc
      git
      htop
      hddtemp
      jq
      lm_sensors
      lz4
      ntfs3g
      nvme-cli
      p7zip
      pciutils
      unrar
      unzip
      wget
      zip
      mdadm
    ];

    loginShellInit = ''
      eval $(ssh-agent)
      gpg-connect-agent /bye
      export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
    '';

    variables = {
      EDITOR = "nano";
      BROWSER = "firefox";
    };
  };
}
