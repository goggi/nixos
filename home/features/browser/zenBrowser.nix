{
  config,
  pkgs,
  ...
}: {
  home = {
    packages = [
      pkgs.zen-browser
    ];
    persistence = {
      "/persist/home/gogsaan" = {
        allowOther = true;
        directories = [
          {
            directory = ".zen";
            method = "symlink";
          }
        ];
      };
    };
  };
}
