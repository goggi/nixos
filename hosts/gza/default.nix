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

  nix.gc = {
    automatic = true;
    randomizedDelaySec = "14m";
  };

  networking = {
    hostName = "gza";
    useDHCP = lib.mkDefault true;
    nameservers = ["1.1.1.1" "8.8.8.8"];
  };

  environment.persistence = {
    "/persist/var" = {
      directories = [
        # Perist virtual machines
        "/var/lib/libvirt"
        # "/var/lib/waydroid/"
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
    kernelModules = ["kvm-amd" "i2c-dev" "kmod-dm-raid" "dm-raid"];
    extraModulePackages = [];
    binfmt.emulatedSystems = ["aarch64-linux" "i686-linux"];
    # kernelPackages = pkgs.linuxKernel.packages.linux_zen;
    # kernelPackages = pkgs.linuxPackages_latest;

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
        configurationLimit = 10;
      };
    };
  };

  services = {
    btrfs.autoScrub.enable = true;
    acpid.enable = true;
    thermald.enable = true;
    # upower.enable = false;
  };

  xdg.portal = {
    enable = true;
    wlr.enable = false;
    extraPortals = [
      pkgs.xdg-desktop-portal-hyprland
    ];
  };

  # programs.steam = {
  #   enable = true;
  #   remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
  #   dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  # };

  # enable hyprland
  # programs.hyprland = {
  #   enable = true;
  #   xwayland.hidpi = true;
  #   package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland; # Steam?
  # };

  # programs.sway = {
  #   enable = true;
  # };

  programs.xwayland.enable = true;
  programs.gnome-disks.enable = true;

  console = let
    normal = ["181825" "F38BA8" "A6E3A1" "F9E2AF" "89B4FA" "F5C2E7" "94E2D5" "BAC2DE"];
    bright = ["1E1E2E" "F38BA8" "A6E3A1" "F9E2AF" "89B4FA" "F5C2E7" "94E2D5" "A6ADC8"];
  in {
    earlySetup = true;
    # colors = normal ++ bright;
    font = "${pkgs.terminus_font}/share/consolefonts/ter-u28n.psf.gz";
    keyMap = "us";
  };

  # console = {
  #   earlySetup = true;
  #   font = "${pkgs.tamzen}/share/consolefonts/Tamzen8x16.psf";
  #   packages = with pkgs; [tamzen];
  # };

  services.xserver.enable = false;
  services.xserver.autorun = true;

  # xserver.displayManager.sessionPackages = [inputs.hyprland.packages.${pkgs.hostPlatform.system}.default];

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
    systemPackages = [
      (pkgs.runCommandLocal "vscode-fhs-bind-host" {} ''
        mkdir -p "$out/bin/"
        substitute \
          "${pkgs.vscode-fhs}/bin/code" \
          "$out/bin/code" \
          --replace "declare -a auto_mounts" "auto_mounts=(--bind-try /etc/nixos /etc/nixos)"
        chmod 555 "$out/bin/code"
      '')
      inputs.bazecor.packages.${pkgs.system}.default
      pkgs.acpi
      pkgs.libva-utils
      pkgs.ocl-icd
      pkgs.qt5.qtwayland
      pkgs.qt5ct
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

  systemd.extraConfig = ''
    DefaultTimeoutStopSec=5s
  '';

  system.stateVersion = lib.mkForce "22.11"; # DONT TOUCH TH
}
