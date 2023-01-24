{pkgs, ...}: let
  udevFiles = [
    {
      name = "10-dygma.rules";
      source = ./10-dygma.rules;
    }
  ];
in {
  environment.systemPackages = with pkgs; [
    writeTextFile
    {
      name = "10-dygma.rules";
      textFiles = udevFiles;
      destination = "/etc/udev/rules.d/10-dygma.rules";
    }
  ];
}
