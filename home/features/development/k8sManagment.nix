{
  lib,
  pkgs,
  ...
}: {
  home = {
    packages = [
      pkgs.k9s
      pkgs.kubectl
      pkgs.kubectl-cnpg
      pkgs.kubernetes-helm
      pkgs.terraform
      pkgs.kustomize
      pkgs.gitkraken
      pkgs.talosctl
      pkgs.hcloud
      pkgs.packer
      pkgs.cloudflare-utils
    ];

    persistence = {
      "/persist/home/gogsaan" = {
        allowOther = true;
        directories = [
          {
            directory = ".config/k9s";
          }
          {
            directory = ".config/hcloud";
          }
        ];
      };
    };
  };
}
