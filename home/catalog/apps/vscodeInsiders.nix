{
  inputs,
  pkgs,
  fetchTarball,
  ...
}: {

  home.persistence = {
    "/persist/home/gogsaan" = {
      allowOther = true;
      directories = [
        ".config/Code - Insiders"
        ".vscode-insiders"
      ];
    };
  };
}
