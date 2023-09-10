{
  lib,
  pkgs,
  ...
}: {
  home = {
    packages = [
      pkgs.k9s
      pkgs.kubectl
      pkgs.kubernetes-helm
      pkgs.terraform
      pkgs.kustomize
      pkgs.gitkraken
    ];

    persistence = {
      "/persist/home/gogsaan" = {
        allowOther = true;
        directories = [".config/k9s"];
      };
    };
  };
}
