{pkgs, ...}: {
  services.udev = {
    # For dygma keyboard
    extraRules = ''
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1209", ATTRS{idProduct}=="2201", GROUP="users", MODE="0666"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1209", ATTRS{idProduct}=="2200", GROUP="users", MODE="0666"
    '';
  };

  # environment.systemPackages = [
  #   pkgs.writeTextFile
  #   {
  #     name = "10-dygma.rules";
  #     text = "SUBSYSTEM==\"usb\", ATTR{idVendor}==\"0483\", ATTR{idProduct}==\"5740\", MODE=\"0666\"";
  #     destination = "/etc/udev/rules.d/10-dygma.rules";
  #   }
  # ];
}
