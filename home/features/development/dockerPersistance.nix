{
  lib,
  pkgs,
  ...
}: {
  home = {
    packages = [
      pkgs.docker-compose
      pkgs.natscli
    ];
    persistence = {
      "/persist/home/gogsaan" = {
        allowOther = true;
        directories = [
          ".config/nats"
          ".local/share/docker"
          ".docker"
          ".github-runner"
        ];
      };
    };
  };
}
