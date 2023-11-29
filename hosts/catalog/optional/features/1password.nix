{
  pkgs,
  config,
  ...
}:
{
  programs = {
    _1password-gui = {
      enable = true;
      polkitPolicyOwners = ["gogsaan"];
      package = pkgs._1password-gui-beta;
    };
    _1password-cli = {
      enable = true;
    };
  };

  environment.etc = {
    "1password/custom_allowed_browsers" = {
      text = ''
        librewolf
        com.microsoft.EdgeDev
      '';
      mode = "0755";
      user = "root";
    };
  };
}
D
