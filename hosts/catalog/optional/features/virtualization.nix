{
  pkgs,
  config,
  ...
}: {
  virtualisation.spiceUSBRedirection.enable = true;

  # # Waydroid
  virtualisation = {
    waydroid.enable = true;
    lxd.enable = true;
  };

  virtualisation.libvirtd = {
    enable = true;

    onShutdown = "suspend";
    onBoot = "ignore";
    qemu = {
      package = pkgs.qemu_kvm;
      ovmf.enable = true;
      swtpm.enable = true;
      runAsRoot = false;
      # ovmf.packages = with pkgs; [pkgs.OVMFFull];
    };
  };

  programs.dconf.enable = true; # Needed to save virt-manager settings
  # systemd.tmpfiles.rules = [
  #   "f /dev/shm/looking-glass 0660 gogsaan qemu-libvirtd -"
  # ];

  environment.etc = {
    "ovmf/edk2-x86_64-secure-code.fd" = {
      source = config.virtualisation.libvirtd.qemu.package + "/share/qemu/edk2-x86_64-secure-code.fd";
    };

    "ovmf/edk2-i386-vars.fd" = {
      source = config.virtualisation.libvirtd.qemu.package + "/share/qemu/edk2-i386-vars.fd";
      mode = "0644";
      user = "libvirtd";
    };
  };

  environment.sessionVariables.LIBVIRT_DEFAULT_URI = ["qemu:///system"];
  environment.systemPackages = with pkgs; [
    virt-manager
    # looking-glass-client # Passthrough GPU
  ];

  environment.persistence = {
    "/persist/var" = {
      directories = [
        "/var/lib/libvirt"
      ];
    };
  };
}
