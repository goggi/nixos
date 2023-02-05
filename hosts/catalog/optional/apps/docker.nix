{pkgs, ...}: {
  # virtualisation.docker = {
  #   enable = true;
  #   setSocketVariable = true;
  # };
  virtualisation.docker.enable = true;
  virtualisation.docker.storageDriver = "btrfs";
}
