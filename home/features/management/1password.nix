{
  lib,
  pkgs,
  ...
}: {
  home = {
    # packages = [
    #   # pkgs._1password-gui
    #   # {
    #   #   enable = true;
    #   #   polkitPolicyOwners = ["gogsaan"];
    #   }
    #   # pkgs._1password
    # ];
    persistence = {
      "/persist/home/gogsaan" = {
        allowOther = true;
        directories = [".config/1Password"];
      };
    };
  };
}
