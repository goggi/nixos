{
  inputs,
  pkgs,
  fetchTarball,
  ...
}: {
  home = {
    packages = [
    pkgs.jetbrains.webstorm
    (pkgs.jetbrains.plugins.addPlugins pkgs.jetbrains.clion [ "nixidea" "github-copilot"])
    ];
    persistence = {
      "/persist/home/gogsaan" = {
        allowOther = true;
              directories = [
                {
                  directory = ".config/JetBrains";
                  method = "symlink";
                }
                {
                  directory = ".local/share/JetBrains";
                  method = "symlink";
                }
              ];
      };
    };
  };
}
