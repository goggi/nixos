{
  lib,
  config,
  ...
}: let
  hostname = config.networking.hostName;
  wipeScript = ''
    mkdir -p /btrfs
    mount -o subvol=/ /dev/disk/by-label/root /btrfs

    if [ -e "/btrfs/root/dontwipe" ]; then
      echo "Not wiping root"
    else
      echo "Cleaning subvolume"
      btrfs subvolume list -o /btrfs/root | cut -f9 -d ' ' |
      while read subvolume; do
        btrfs subvolume delete "/btrfs/$subvolume"
      done && btrfs subvolume delete /btrfs/root

      echo "Restoring blank subvolume"
      btrfs subvolume snapshot /btrfs/root-blank /btrfs/root
    fi

    umount /btrfs
    rm /btrfs
  '';
in {
  boot.initrd.supportedFilesystems = ["btrfs"];

  # Use postDeviceCommands if on old phase 1
  boot.initrd.postDeviceCommands = lib.mkBefore wipeScript;

  fileSystems."/persist" = {
    device = "/dev/disk/by-label/root";
    fsType = "btrfs";
    options = ["subvol=persist" "compress=zstd" "noatime" "ssd" "space_cache=v2"];
    neededForBoot = true;
  };

  fileSystems."/home/gogsaan/.vscode" = {
    device = "/dev/disk/by-label/root";
    fsType = "btrfs";
    options = ["subvol=vscodeExtentions" "compress=zstd" "noatime" "ssd" "space_cache=v2"];
    neededForBoot = true;
  };

  fileSystems."/var/log" = {
    device = "/dev/disk/by-label/root";
    fsType = "btrfs";
    options = ["subvol=log" "compress=zstd" "noatime" "ssd" "space_cache=v2"];
    neededForBoot = true;
  };
}
