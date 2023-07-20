{
  inputs,
  pkgs,
  fetchTarball,
  ...
}: {
  home = {
    packages = [
      pkgs.jetbrains.webstorm
    ];
  };
}
