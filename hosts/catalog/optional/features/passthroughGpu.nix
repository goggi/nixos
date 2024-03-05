{pkgs, ...}: {
  boot = {
    # Passtrough GPU
    initrd.preDeviceCommands = ''
      DEVS="0000:24:00.0 0000:24:00.1"
      for DEV in $DEVS; do
        echo "vfio-pci" > /sys/bus/pci/devices/$DEV/driver_override
      done
      modprobe -i vfio-pci
    '';
    kernelParams = [
      "amd_iommu=on"
      "vfio-pci.ids=10de:1e84,10de:10f8,10de:1ad8,10de:1ad9"
    ];

    initrd.kernelModules = [
      "vfio_pci"
      "vfio"
      "vfio_iommu_type1"
    ];
  };
}
