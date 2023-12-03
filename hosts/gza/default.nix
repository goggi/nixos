{
  lib,
  pkgs,
  inputs,
  config,
  ...
}: {
  imports = [
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
    ../catalog/optional/features/1password.nix
    ../catalog/optional/features/dygma.nix
    ../catalog/optional/features/pipewire.nix
    ../catalog/optional/features/plex.nix
    ../catalog/optional/features/flatpak.nix

    ../catalog/optional/apps/docker.nix
    ../catalog/optional/apps/bazecor.nix
  ];

  nix.gc.automatic = true;

  networking = {
    hostName = "gza";
    useDHCP = lib.mkDefault true;
  };

  environment.persistence = {
    "/persist/var" = {
      directories = [
        "/var/lib/bluetooth"
      ];
    };
  };

  boot = {
    initrd.kernelModules = [
      "raid1"
      "dm-snapshot"
      "dm-cache-default"
      "dm-raid"
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
    kernelModules = ["amdgpu" "kvm-amd" "i2c-dev" "kmod-dm-raid" "dm-raid"];
    extraModulePackages = [];
    binfmt.emulatedSystems = ["aarch64-linux" "i686-linux"];
    # kernelPackages = pkgs.linuxKernel.packages.linux_zen;
    # kernelPackages = pkgs.linuxKernel.packages.linux_xanmod_latest;
    kernelPackages = pkgs.linuxPackages_latest;
    # kernelPackages = pkgs.linuxPackages_6_6;

    kernel.sysctl = {
      "vm.max_map_count" = 16777216;
      "fs.file-max" = 524288;
    };

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
        "dm_thin_pool"
        "dm-raid"
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
        device = "nodev";
        efiSupport = true;
        useOSProber = false;
        enableCryptodisk = true;
        configurationLimit = 50;
        gfxmodeEfi = "1024x768";
      };
    };
  };

  xdg.portal = {
    enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-hyprland pkgs.xdg-desktop-portal-gtk pkgs.xdg-desktop-portal-wlr pkgs.xdg-desktop-portal];
    configPackages = [pkgs.hyprland];
    config.common.default = "*";
  };

  systemd.extraConfig = ''
    DefaultTimeoutStopSec=5s
  '';

  system.stateVersion = lib.mkForce "23.11";
}
