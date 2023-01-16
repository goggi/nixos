{
  pkgs,
  config,
  lib,
  ...
}: let
  fetchKey = {
    url,
    sha256 ? lib.fakeSha256,
  }:
    builtins.fetchurl {inherit sha256 url;};

  pinentry =
    if config.gtk.enable
    then {
      package = pkgs.pinentry-gnome;
      name = "gnome3";
    }
    else {
      package = pkgs.pinentry-curses;
      name = "curses";
    };
in {
  home.packages = [pinentry.package];

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    sshKeys = ["75F1DD709E676C7C56E0F5477BFF856B0CB7870A"];
    pinentryFlavor = pinentry.name;
    enableExtraSocket = true;
  };

  programs = let
    fixGpg = ''
      gpgconf --launch gpg-agent
    '';
  in {
    # Start gpg-agent if it's not running or tunneled in
    # SSH does not start it automatically, so this is needed to avoid having to use a gpg command at startup
    # https://www.gnupg.org/faq/whats-new-in-2.1.html#autostart
    bash.profileExtra = fixGpg;
    fish.loginShellInit = fixGpg;
    zsh.loginExtra = fixGpg;

    gpg = {
      enable = true;
      settings = {
        trust-model = "tofu+pgp";
      };
      publicKeys = [
        {
          source = "/persist/home/gogsaan/Documents/Auth/033E4036D8E78DEFDE28692373ECBA45B94F96B1.asc";
          trust = 5;
        }
      ];
    };
  };

  # home.persistence = {
  #   "/persist/home/gogsaan".directories = [".gnupg"];
  # };

  # Link /run/user/$UID/gnupg to ~/.gnupg-sockets
  # So that SSH config does not have to know the UID
  systemd.user.services.link-gnupg-sockets = {
    Unit = {
      Description = "link gnupg sockets from /run to /home";
    };
    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.coreutils}/bin/ln -Tfs /run/user/%U/gnupg %h/.gnupg-sockets";
      ExecStop = "${pkgs.coreutils}/bin/rm $HOME/.gnupg-sockets";
      RemainAfterExit = true;
    };
    Install.WantedBy = ["default.target"];
  };
}
# vim: filetype=nix

