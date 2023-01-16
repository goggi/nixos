{
  lib,
  pkgs,
  inputs,
  config,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    ../catalog/global
    ../catalog/users/gogsaan.nix
    ../catalog/optional/features/amdGpu.nix
    ../catalog/optional/features/gamemode.nix
    ../catalog/optional/features/virtualization.nix
    ../catalog/optional/features/btrfsOptinPersistence.nix
    ../catalog/optional/features/encryptedRoot.nix
    ../catalog/optional/apps/podman.nix
    # ../catalog/optional/apps/taskwarrior.nix
  ];

  networking = {
    hostName = "gza";
    useDHCP = lib.mkDefault true;
  };

  boot = {
    initrd.kernelModules = ["dm-snapshot" "amdgpu"];
    kernelModules = ["kvm-amd" "i2c-dev"];
    extraModulePackages = [];
    binfmt.emulatedSystems = ["aarch64-linux"];
    # kernelPackages = pkgs.linuxKernel.packages.linux_zen;
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [];
    initrd.availableKernelModules =
      [
        "xhci_pci"
        "thunderbolt"
        "nvme"
        "usb_storage"
        "sd_mod"
      ]
      ++ config.boot.initrd.luks.cryptoModules;

    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };

      systemd-boot.enable = false;

      grub = {
        enable = true;
        version = 2;
        device = "nodev";
        efiSupport = true;
        useOSProber = false;
        enableCryptodisk = true;
        configurationLimit = 20;
      };
    };
  };

  services = {
    btrfs.autoScrub.enable = true;
    acpid.enable = true;
    thermald.enable = true;
    upower.enable = false;

    greetd = {
      enable = true;
      settings = rec {
        initial_session = {
          command = "Hyprland";
          user = "gogsaan";
        };
        default_session = initial_session;
      };
    };
    # add hyprland to display manager sessions
    xserver.displayManager.sessionPackages = [inputs.hyprland.packages.${pkgs.system}.default];
  };

  # selectable options
  environment.etc."greetd/environments".text = ''
    Hyprland
  '';

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
  };

  # enable hyprland
  programs.hyprland.enable = true;
  programs.xwayland.enable = true;
  services.xserver.enable = false;

  services.gnome.gnome-keyring.enable = true;
  security = {
    polkit.enable = true;
    pam.services.swaylock = {
      text = ''
        auth include login
      '';
    };
  };

  environment = {
    systemPackages = with pkgs; [
      # inputs.bazecor.packages.${pkgs.system}.default
      acpi
      libva-utils
      ocl-icd
      qt5.qtwayland
      qt5ct
      # gamescope
      # mangohud
    ];

    variables = {
      NIXOS_OZONE_WL = "1";
    };
  };

  services.logind.extraConfig = ''
    # don’t shutdown when power button is short-pressed
    HandlePowerKey=ignore
  '';

  system.stateVersion = lib.mkForce "22.11"; # DONT TOUCH THIS
}
