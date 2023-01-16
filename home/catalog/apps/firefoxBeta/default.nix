{
  config,
  pkgs,
  ...
}: {
  programs.librewolf = {
    enable = true;

    package = pkgs.firefox-beta-bin-unwrapped;

    profiles = {
      gogsaan = {
        id = 0;
        settings = {
          "general.smoothScroll" = true;
        };

        userChrome = import ./userChrome-css.nix;
        userContent = import ./userContent-css.nix;

        extraConfig = ''
          user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
          user_pref("full-screen-api.ignore-widgets", true);
          user_pref("media.ffmpeg.vaapi.enabled", true);
          user_pref("media.rdd-vpx.enabled", true);
        '';
      };
    };
  };
}
