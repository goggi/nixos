{pkgs, ...}: {
  environment.persistence = {
    "/persist/etc" = {
      directories = [
        "/rancher/k3s"
      ];
    };
  };

  # This is required so that pod can reach the API server (running on port 6443 by default)
  networking.firewall.allowedTCPPorts = [6443];
  services.k3s.enable = true;
  services.k3s.role = "server";
  services.k3s.extraFlags = toString [
    "--write-kubeconfig-mode 655"
    "--kubelet-arg=v=4" # Optionally add additional args to k3s
  ];
  systemd.services.etcd.preStart = ''${pkgs.writeShellScript "etcd-wait" ''
      while [ ! -f /var/lib/kubernetes/secrets/etcd.pem ]; do sleep 1; done
    ''}'';
  environment.systemPackages = [pkgs.k3s];
}
