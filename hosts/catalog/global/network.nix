{
  config,
  pkgs,
  lib,
  ...
}: {
  networking = {
    extraHosts = ''
      127.0.0.1 modules-cdn.eac-prod.on.epicgames.com
      10.0.0.1 server
    '';

    networkmanager = {
      enable = true;
      unmanaged = ["docker0" "rndis0"];
      wifi.macAddress = "random";
    };

    firewall = {
      enable = true;
      allowPing = false;
      logReversePathDrops = true;
    };
  };

  # slows down boot time
  systemd.services.NetworkManager-wait-online.enable = false;
}
