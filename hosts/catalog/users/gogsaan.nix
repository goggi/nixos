{
  pkgs,
  config,
  lib,
  outputs,
  ...
}: let
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in {
  services.geoclue2.enable = true;
  users.mutableUsers = true;
  users.users.gogsaan = {
    description = "Gogsaan";
    isNormalUser = true;
    shell = pkgs.fish;
    passwordFile = config.sops.secrets.gogsaan-password.path;
    extraGroups =
      [
        "i2c"
        "wheel"
        "networkmanager"
        "video"
        "audio"
        "nix"
        "systemd-journal"
      ]
      ++ ifTheyExist [
        "docker"
        "git"
        "libvirtd"
        "mysql"
        "libvirt-qemu"
        "qemu-libvirtd"
        "kvm"
      ];

    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDJDL0+n9LyNV07t+gF7r+AXWAgyRjdbZRI/wfzQuO1KraqAjorIiGXOIYc8hGbs3J5ABnOVTylfp+nPmpa35LTXppR0ulTXjBJSp4GjRpBTQvL2okmzJ+f+M75m5SxKSdZ/TqOc66r8Ezc9XxFbwJrFj9KM2hoBkeJSBGWdopbsKq3wl4KHuw+aecOwJMGfWLLS/iIAc9AAcAwF76TT66rQIJlWokeT/lC0/MZmyZ3N4iMrWL6yYcSzTs8v+tFU6WGIj0zRSAnI1vEZPQQoHa+Bc0fMvdUMl/IBZ5BxXSLs3Xb5Sj8LfC/pwuMZsd+HPYbnkq3W2DAP0m6KZ1x8WNAGByxqipTIPRVQl/SPabBeEFjg0dZik/Szv+r1/jkLSd4XYOMWPf7BspL5LrFB82AEGyFogh08/OAaIWrZm1fKfAByKH1Wp9ObwoCE+8X6xczJfOQ3T8/hz77iugkn4vm+G/ilUfhAmsq/jVn5mNtpdnLO0bJq8H/OBO0OirCYEql+w+w1jLsqq/gtPKPPl/a2DJRPisObmDpvzWDO4qYXbvB5Nziek0XvP0a6pYc9zVoM+vXLFpsxgEvupxzUKhWcaC3y/Hq4WqI6CtGeNlu8RnuoOBvS//H/BnF7FRfpaUFrPoq7HTLo+FOKW3rz7XJo7Ek5cjWTotr+8ijLxtGKQ== Goran Cinklovic"
    ];
  };
  sops.secrets.gogsaan-password = {
    sopsFile = ../../catalog/secrets.yaml;
    neededForUsers = true;
  };
  programs.fish.enable = true;
  programs.zsh.enable = true;

  programs = {
    _1password-gui = {
      enable = true;
      polkitPolicyOwners = ["gogsaan"];
    };
  };
}
