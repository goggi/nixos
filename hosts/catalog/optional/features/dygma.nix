{pkgs, ...}: {
  services.udev = {
    # For dygma keyboard
    extraRules = ''
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1209", ATTRS{idProduct}=="2201", GROUP="users", MODE="0666"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1209", ATTRS{idProduct}=="2200", GROUP="users", MODE="0666"
    '';
  };
}
