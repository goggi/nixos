{
  lib,
  pkgs,
  inputs,
  config,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    inputs.impermanence.nixosModules.impermanence
    ./hardware-configuration.nix

    ../catalog/global
    ../catalog/users/gogsaan.nix
    ../catalog/optional/features/amdGpu.nix
    ../catalog/optional/features/gamemode.nix
    ../catalog/optional/features/virtualization.nix
    ../catalog/optional/features/btrfsOptinPersistence.nix
    ../catalog/optional/features/encryptedRoot.nix
    ../catalog/optional/features/flatpakIconFix.nix
    ../catalog/optional/features/greetd.nix
    # ../catalog/optional/features/quietBoot.nix
    ../catalog/optional/features/pipewire.nix

    ../catalog/optional/apps/docker.nix
    # ../catalog/optional/apps/bazecor.nix
    # ../catalog/optional/apps/taskwarrior.nix
  ];

  services.flatpak.enable = true;

  networking = {
    hostName = "gza";
    useDHCP = lib.mkDefault true;
  };

  environment.persistence = {
    "/persist/var" = {
      directories = [
        # Perist virtual machines
        "/var/lib/libvirt"
      ];
    };
    "/persist/etc" = {
      directories = [
        # Perist networkpasswords
        "/etc/NetworkManager/system-connections"
      ];
    };
  };

  boot = {
    initrd.kernelModules = [
      "dm-snapshot"
      "amdgpu"
      # Passtrough GPU
      "vfio_pci"
      "vfio"
      "vfio_iommu_type1"
      # "vfio_virqfd"
    ];
    kernelParams = [
      "amd_iommu=on"
      "vfio-pci.ids=10de:1e84,10de:10f8,10de:1ad8,10de:1ad9"
    ];
    kernelModules = ["kvm-amd" "i2c-dev"];
    extraModulePackages = [];
    binfmt.emulatedSystems = ["aarch64-linux" "i686-linux"];
    # kernelPackages = pkgs.linuxKernel.packages.linux_zen;
    kernelPackages = pkgs.linuxPackages_latest;

    # Passtrough GPU
    initrd.preDeviceCommands = ''
      DEVS="0000:24:00.0 0000:24:00.1"
      for DEV in $DEVS; do
        echo "vfio-pci" > /sys/bus/pci/devices/$DEV/driver_override
      done
      modprobe -i vfio-pci
    '';

    initrd.availableKernelModules =
      [
        "xhci_pci"
        "nvme"
        "usb_storage"
        "sd_mod"
        "usbhid"
        "vfio-pci"
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
  };

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
  # xserver.displayManager.sessionPackages = [inputs.hyprland.packages.${pkgs.system}.default];

  # services.gnome.gnome-keyring.enable = true;
  security = {
    polkit.enable = true;
    pam.services.swaylock = {
      text = ''
        auth include login
      '';
    };
  };

  services.udev = {
    # For dygma keyboard
    extraRules = ''
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1209", ATTRS{idProduct}=="2201", GROUP="users", MODE="0666"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1209", ATTRS{idProduct}=="2200", GROUP="users", MODE="0666"
    '';
  };

  environment = {
    systemPackages = with pkgs; [
      inputs.bazecor.packages.${pkgs.system}.default
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

  system.stateVersion = lib.mkForce "22.11"; # DONT TOUCH TH
}
