{
  config,
  pkgs,
  lib,
  outputs,
  ...
}: let
  hosts = outputs.nixosConfigurations;
  # hostname = config.networking.hostName;
  prefix = "/persist";
  pubKey = host: ../../${host}/ssh_host_ed25519_key.pub;
in {
  services.openssh = {
    enable = true;
    openFirewall = true;
    forwardX11 = false;
    ports = [49022];
    # settings.kbdInteractiveAuthentication = false;
    # settings.passwordAuthentication = lib.mkForce false;
    # settings.permitRootLogin = lib.mkForce "no";
    # settings.useDns = false;

    hostKeys = [
      # {
      #   bits = 4096;
      #   # path = "/etc/ssh/ssh_host_rsa_key";
      #   path = "${prefix}/home/gogsaan/Documents/Auth/033E4036D8E78DEFDE28692373ECBA45B94F96B1.pgp";
      #   # path = "${prefix}/etc/ssh/ssh_host_rsa_key";
      #   type = "rsa";
      # }
      {
        # path = "/etc/ssh/ssh_host_ed25519_key";
        path = "${prefix}/etc/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
    ];
  };

  programs.ssh.startAgent = true;
}
