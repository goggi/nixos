{
  boot.initrd.luks.devices.luksroot = {
    device = "/dev/disk/by-label/cryptroot";
    preLVM = true;
    allowDiscards = true;
  };
}
