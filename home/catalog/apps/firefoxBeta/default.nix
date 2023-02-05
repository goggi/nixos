{
  config,
  pkgs,
  ...
}: {
  home = {
    packages = [
      (pkgs.runCommand "firefox-old" {preferLocalBuild = true;} ''
        mkdir -p $out/bin
        ln -s ${pkgs.firefox}/bin/firefox $out/bin/firefox-old
      '')
      pkgs.firefox-beta-bin-unwrapped
    ];

    # persistence = {
    #   "/persist/home/gogsaan" = {
    #     allowOther = true;
    #     directories = [".mozilla-beta"];
    #   };
    # };
  };
}
