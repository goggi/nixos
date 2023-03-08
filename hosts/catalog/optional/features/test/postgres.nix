{pkgs, ...}: {
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_14;
    enableTCPIP = true;
    dataDir = "/persist/home/gogsaan/Documents/Database/postgres";
    authentication = pkgs.lib.mkOverride 10 ''
      local all all trust
      host all all 127.0.0.1/32 trust
      host all all ::1/128 trust
    '';
    initialScript = pkgs.writeText "backend-initScript" ''
      CREATE ROLE coder WITH LOGIN PASSWORD 'coder' CREATEDB;
      CREATE DATABASE coder;
      GRANT ALL PRIVILEGES ON DATABASE coder TO coder;
    '';
  };
}
