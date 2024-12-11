{
  pkgs,
  config,
  ...
}: {
  programs = {
    _1password-gui = {
      enable = true;
      polkitPolicyOwners = ["gogsaan"];
    };
    _1password = {
      enable = true;
    };
  };

  environment.etc = {
    "1password/custom_allowed_browsers" = {
      text = ''
        vivaldi-bin
        wavebox
        vivaldi
        zen
        .zen-wrapped
      '';
      mode = "0755";
    };
  };
}
