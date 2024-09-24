{
  pkgs,
  config,
  ...
}: {
  # Yubikey
  services.udev.extraRules = ''
    # Yubikey 4/5 U2F+CCID
    SUBSYSTEM=="usb", ATTR{idVendor}=="1050", ATTR{idProduct}=="0406", ENV{ID_SECURITY_TOKEN}="1", GROUP="wheel"
  '';
  services.udev.packages = [pkgs.yubikey-personalization];
  programs.gnupg.agent = {
    enable = true;
  };
  security.pam.services = {
    greetd.enableGnomeKeyring = true;
    login.u2fAuth = true;
    sudo.u2fAuth = true;
  };
  security.pam.yubico = {
    enable = true;
    debug = true;
    mode = "challenge-response";
  };
  services.pcscd.enable = true;
}
