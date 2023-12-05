{
  config,
  pkgs,
  ...
}: {
  home = {
    packages = [
      pkgs.waterfox
    ];
    persistence = {
      "/persist/home/gogsaan" = {
        allowOther = true;
        directories = [
          {
            directory = ".waterfox";
            method = "symlink";
          }
        ];
      };
    };
  };
}
