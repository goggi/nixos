{
  config,
  pkgs,
  ...
}: {
  home = {
    packages = [
      pkgs.librewolf
    ];
    persistence = {
      "/persist/home/gogsaan" = {
        allowOther = true;
        directories = [
          {
            directory = ".librewolf";
            method = "symlink";
          }
        ];
      };
    };
  };
}
