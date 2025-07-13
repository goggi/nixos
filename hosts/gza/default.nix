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
    # ../catalog/optional/features/passthroughGpu.nix

    ../catalog/optional/features/gnomeKeyRing.nix
    ../catalog/optional/features/encryptedRoot.nix
    ../catalog/optional/features/flatpakIconFix.nix
    ../catalog/optional/features/greetd.nix
    ../catalog/optional/features/1password.nix
    ../catalog/optional/features/dygma.nix
    ../catalog/optional/features/pipewire.nix
    # ../catalog/optional/features/plex.nix
    ../catalog/optional/features/flatpak.nix
    ../catalog/optional/apps/docker.nix
    ../catalog/optional/apps/bazecor.nix
  ];

  nixpkgs.overlays = [
    (final: prev: {
      dqlite = prev.dqlite.overrideAttrs (oldAttrs: {
        postPatch = (oldAttrs.postPatch or "") + ''
          find src -name "*.h" -o -name "*.c" | xargs sed -i 's/\bfloat_t\b/dqlite_float_t/g'
        '';
      });
    })
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
        "/var/lib/systemd/coredump"
        "/var/lib/nixos"
        "/var/lib/github-runner"
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
      # "vfio_pci"
      # "vfio"
      # "vfio_iommu_type1"
      # "vfio_virqfd"
    ];

    kernelModules = ["amdgpu" "kvm-amd" "i2c-dev" "kmod-dm-raid" "dm-raid"];
    extraModulePackages = [];
    binfmt.emulatedSystems = ["aarch64-linux" "i686-linux"];
    # kernelPackages = pkgs.linuxKernel.packages.linux_zen;
    # kernelPackages = pkgs.linuxKernel.packages.linux_xanmod_latest;
    # kernelPackages = pkgs.linuxPackages_latest;
    # kernelPackages = pkgs.linuxPackages_6_12;

    kernel.sysctl = {
      "vm.max_map_count" = 16777216;
      "fs.file-max" = 524288;
    };

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

    postBootCommands = ''
      if [ -d "/var/lib/github-runner" ]; then
        echo "Cleaning GitHub runner directory at boot time"
        rm -rf /var/lib/github-runner/*
        chown -R runner:runner /var/lib/github-runner
        chmod -R 0770 /var/lib/github-runner
      fi
    '';
  };

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    config = {
      common.default = ["gtk"];
      hyprland.default = ["gtk" "hyprland"];
    };
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-wlr
      pkgs.xdg-desktop-portal
      pkgs.xdg-desktop-portal-hyprland
    ];
  };

  systemd.extraConfig = ''
    DefaultTimeoutStopSec=5s
  '';

  system.stateVersion = lib.mkForce "23.11";


  services = {
    github-runners = {
      runner = {
        enable = true;
        name = "Gza-DT Runner";
        user = "root";
        group = "docker";
        tokenFile = "/home/gogsaan/Documents/githubtoken";
        url = "https://github.com/TrendeeLabs";
        extraPackages = [
          pkgs.docker
          pkgs.docker-compose
          pkgs.docker-buildx
          pkgs.git
          pkgs.kustomize
        ];
      };
    };
  };


}
