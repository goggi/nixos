{lib, ...}: {
  i18n = {
    defaultLocale = lib.mkDefault "en_US.UTF-8";

    extraLocaleSettings = {
      LC_TIME = lib.mkDefault "sv_SE.UTF-8";
    };

    supportedLocales = lib.mkDefault [
      "en_US.UTF-8/UTF-8"
      "pt_BR.UTF-8/UTF-8"
      "sv_SE.UTF-8/UTF-8"
    ];
  };

  # services.ntp.enable = true;
  # services.localtimed.enable = true;
  time = {
    timeZone = lib.mkDefault "Europe/Stockholm";
    hardwareClockInLocalTime = false;
  };
}
