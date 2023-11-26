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

  # services.gnome.gnome-keyring.enable = true;

  security = {
    rtkit.enable = true;

    apparmor = {
      enable = true;
      killUnconfinedConfinables = true;
      packages = [pkgs.apparmor-profiles];
    };

    pam = {
      # services.login.enableGnomeKeyring = true;

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

    udev.packages = with pkgs; [gnome.gnome-settings-daemon];

    dbus = {
      enable = true;
      packages = with pkgs; [dconf gcr];
    };

    logind = {
      lidSwitch = "suspend-then-hibernate";
      lidSwitchExternalPower = "lock";
      extraConfig = ''
        HandlePowerKey=suspend-then-hibernate
        HibernateDelaySec=3600
      '';
    };
  };

  programs = {
    bash.promptInit = ''eval "$(${pkgs.starship}/bin/starship init bash)"'';
    fish.promptInit = ''eval "$(${pkgs.starship}/bin/starship init fish | source)"'';

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

  # environment.sessionVariables.POLKIT_AUTH_AGENT = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";

  environment = {
    binsh = "${pkgs.bash}/bin/bash";
    shells = with pkgs; [fish];
    # shells = with pkgs; [zsh];

    systemPackages = with pkgs; [
      # polkit
      # polkit_gnome
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
      # dbus-update-activation-environment --systemd DISPLAY
      # eval $(gnome-keyring-daemon --start --daemonize --components=ssh)
      eval $(ssh-agent)
      gpg-connect-agent /bye
      export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
      # home-manager switch --flake .#gogsaan@gza
      # sudo rm -r /var/lib/waydroid
      # sudo ln -s /persist/var/var/lib/waydroid/ /var/lib/waydroid
    '';

    variables = {
      EDITOR = "nano";
      BROWSER = "firefox";
    };
  };
}
