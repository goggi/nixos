{
  config,
  pkgs,
  ...
}: {
  home = {
    packages = [
      pkgs.floorp
    ];
    persistence = {
      "/persist/home/gogsaan" = {
        allowOther = true;
        directories = [
          {
            directory = ".floorp";
            method = "symlink";
          }
        ];
      };
    };
  };
}
