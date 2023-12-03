{
  services.plex = {
    enable = true;
    dataDir = "/var/lib/plex";
    openFirewall = true;
    user = "gogsaan";
    group = "users";
  };

  environment.persistence = {
    "/persist/var" = {
      directories = [
        "/var/lib/plex"
      ];
    };
  };
}
