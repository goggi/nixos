{pkgs, ...}: {
  environment.systemPackages = [
    pkgs.writeTextFile
    {
      name = "10-dygma.rules";
      text = "SUBSYSTEM==\"usb\", ATTR{idVendor}==\"0483\", ATTR{idProduct}==\"5740\", MODE=\"0666\"";
      destination = "/etc/udev/rules.d/10-dygma.rules";
    }
  ];
}
