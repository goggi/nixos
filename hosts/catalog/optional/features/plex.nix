{
  services.plex.enable = true;
  services.plex.openFirewall = true;

  environment.persistence = {
    "/persist/var" = {
      directories = [
        "/var/lib/plex"
      ];
    };
  };
}
