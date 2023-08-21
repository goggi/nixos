# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: let
  hostname = config.networking.hostName;
in {
  # Hardware configuration
  hardware = {
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [
        vaapiVdpau
        libvdpau-va-gl
      ];
    };

    bluetooth = {
      enable = true;
      package = pkgs.bluez;
    };

    enableRedistributableFirmware = true;
    pulseaudio.enable = false;
  };

  imports = [(modulesPath + "/installer/scan/not-detected.nix")];

  fileSystems."/" = {
    device = "/dev/disk/by-label/root";
    fsType = "btrfs";
    options = ["subvol=root" "compress=zstd" "noatime" "ssd" "space_cache=v2"];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-label/root";
    fsType = "btrfs";
    options = ["subvol=nix" "compress=zstd" "noatime" "ssd" "space_cache=v2"];
  };

  fileSystems."/var/lib/docker" = {
    device = "/dev/disk/by-label/root";
    fsType = "btrfs";
    options = ["subvol=docker" "compress=zstd" "noatime" "ssd" "space_cache=v2"];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/boot";
    fsType = "vfat";
  };

  # fileSystems."/home/gogsaan/Drives/fun" = {
  #   device = "/dev/disk/by-label/Fun";
  #   fsType = "ext4";
  # };

  fileSystems."/home/gogsaan/Drives/other" = {
    device = "/dev/disk/by-label/Other";
    options = ["nofail"];
    fsType = "ext4";
  };

  services.lvm.boot.thin.enable = true;
  fileSystems."/home/gogsaan/Drives/backup" = {
    device = "/dev/volgroup_mirror/backup";
    options = ["nofail"];
    fsType = "ext4";
  };

  swapDevices = [
    {device = "/dev/disk/by-label/swap";}
  ];

  networking.useDHCP = lib.mkDefault true;
  networking.firewall.allowedTCPPorts = [25565];
  networking.firewall.allowedUDPPorts = [19132];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # DDCUTIL
  hardware.i2c.enable = true;
}
