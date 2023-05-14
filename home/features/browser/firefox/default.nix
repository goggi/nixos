{
  config,
  pkgs,
  ...
}: {
  home = {
    persistence = {
      "/persist/home/gogsaan" = {
        allowOther = true;
        directories = [".mozilla"];
      };
    };
  };
  programs.firefox = {
    enable = true;

    package = pkgs.wrapFirefox pkgs.firefox-unwrapped {
      extraPolicies = {
        CaptivePortal = false;
        DisableFirefoxStudies = true;
        DisablePocket = true;
        DisableTelemetry = true;
        DisableFirefoxAccounts = false;
        NoDefaultBookmarks = true;
        OfferToSaveLogins = false;
        OfferToSaveLoginsDefault = false;
        PasswordManagerEnabled = false;
        # FirefoxHome = {
        #   Search = true;
        #   Pocket = false;
        #   Snippets = false;
        #   TopSites = false;
        #   Highlights = false;
        # };
        UserMessaging = {
          ExtensionRecommendations = false;
          SkipOnboarding = true;
        };
      };
    };

    profiles = {
      gogsaan = {
        name = "gogsaan";
        id = 0;

        # extensions = with pkgs.nur.repos.rycee.firefox-addons; [
        #   adnauseam
        #   enhanced-github
        #   enhancer-for-youtube
        #   octotree
        #   refined-github
        #   stylus
        #   ublock-origin
        # ];
        search = {
          force = true;
          default = "google";

          engines = {
            "Youtube" = {
              urls = [
                {
                  template = "https://www.youtube.com/results?search_query={searchTerms}";
                  params = [
                    {
                      name = "type";
                      value = "packages";
                    }
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              definedAliases = ["y"];
            };
            "Nix Packages" = {
              urls = [
                {
                  template = "https://search.nixos.org/packages";
                  params = [
                    {
                      name = "type";
                      value = "packages";
                    }
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              definedAliases = ["np"];
            };
            "NixOS Wiki" = {
              urls = [{template = "https://nixos.wiki/index.php?search={searchTerms}";}];
              iconUpdateURL = "https://nixos.wiki/favicon.png";
              updateInterval = 24 * 60 * 60 * 1000;
              definedAliases = ["nw"];
            };
            # "Wikipedia (en)".metaData.alias = "@wiki";
            # "Google".metaData.hidden = true;
            # "Amazon.com".metaData.hidden = true;
            # "Bing".metaData.hidden = true;
            # "eBay".metaData.hidden = true;
          };
        };

        settings = {
          # Smooth scroll
          "general.smoothScroll" = true;

          # Force using WebRender. Improve performance
          "gfx.webrender.all" = true;
          "gfx.webrender.enabled" = true;

          # https://wiki.archlinux.org/title/firefox#Hardware_video_acceleration
          "media.ffmpeg.vaapi.enabled" = true;
          "media.ffvpx.enabled" = false;

          # Enable multi-pip
          "media.videocontrols.picture-in-picture.allow-multiple" = true;

          # Misc
          "browser.aboutConfig.showWarning" = false;
          "browser.tabs.warnOnClose" = false;
          "widget.use-xdg-desktop-portal" = true;
          "ui.context_menus.after_mouseup" = true;
          "browser.toolbars.bookmarks.visibility" = "never";
          "browser.disableResetPrompt" = true;

          # Tab
          "browser.urlbar.suggest.quickactions" = false;
          "browser.urlbar.suggest.topsites" = false;
        };

        extraConfig = ''
          user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
          user_pref("full-screen-api.ignore-widgets", true);
          user_pref("media.ffmpeg.vaapi.enabled", true);
          user_pref("media.rdd-vpx.enabled", true);
        '';

        userChrome = import ./userChrome-css.nix;
        userContent = import ./userContent-css.nix;
      };
      coder = {
        name = "coder";
        id = 1;

        search = {
          force = true;
          default = "google";

          engines = {
            "Youtube" = {
              urls = [
                {
                  template = "https://www.youtube.com/results?search_query={searchTerms}";
                  params = [
                    {
                      name = "type";
                      value = "packages";
                    }
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              definedAliases = ["y"];
            };
            "Nix Packages" = {
              urls = [
                {
                  template = "https://search.nixos.org/packages";
                  params = [
                    {
                      name = "type";
                      value = "packages";
                    }
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              definedAliases = ["np"];
            };
            "NixOS Wiki" = {
              urls = [{template = "https://nixos.wiki/index.php?search={searchTerms}";}];
              iconUpdateURL = "https://nixos.wiki/favicon.png";
              updateInterval = 24 * 60 * 60 * 1000;
              definedAliases = ["nw"];
            };
            # "Wikipedia (en)".metaData.alias = "@wiki";
            # "Google".metaData.hidden = true;
            # "Amazon.com".metaData.hidden = true;
            # "Bing".metaData.hidden = true;
            # "eBay".metaData.hidden = true;
          };
        };

        settings = {
          # Smooth scroll
          "general.smoothScroll" = true;

          # Force using WebRender. Improve performance
          "gfx.webrender.all" = true;
          "gfx.webrender.enabled" = true;

          # https://wiki.archlinux.org/title/firefox#Hardware_video_acceleration
          "media.ffmpeg.vaapi.enabled" = true;
          "media.ffvpx.enabled" = false;

          # Enable multi-pip
          "media.videocontrols.picture-in-picture.allow-multiple" = true;

          # Misc
          "browser.aboutConfig.showWarning" = false;
          "browser.tabs.warnOnClose" = false;
          "widget.use-xdg-desktop-portal" = true;
          "ui.context_menus.after_mouseup" = true;
          "browser.toolbars.bookmarks.visibility" = "never";
          "browser.disableResetPrompt" = true;

          # Tab
          "browser.urlbar.suggest.quickactions" = false;
          "browser.urlbar.suggest.topsites" = false;
        };

        extraConfig = ''
          user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
          user_pref("full-screen-api.ignore-widgets", true);
          user_pref("media.ffmpeg.vaapi.enabled", true);
          user_pref("media.rdd-vpx.enabled", true);
        '';

        userChrome = import ./userChrome-css.nix;
        userContent = import ./userContent-css.nix;
      };
      tui = {
        name = "tui";
        id = 2;

        search = {
          force = true;
          default = "google";

          engines = {
            "Youtube" = {
              urls = [
                {
                  template = "https://www.youtube.com/results?search_query={searchTerms}";
                  params = [
                    {
                      name = "type";
                      value = "packages";
                    }
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              definedAliases = ["y"];
            };
            "Nix Packages" = {
              urls = [
                {
                  template = "https://search.nixos.org/packages";
                  params = [
                    {
                      name = "type";
                      value = "packages";
                    }
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              definedAliases = ["np"];
            };
            "NixOS Wiki" = {
              urls = [{template = "https://nixos.wiki/index.php?search={searchTerms}";}];
              iconUpdateURL = "https://nixos.wiki/favicon.png";
              updateInterval = 24 * 60 * 60 * 1000;
              definedAliases = ["nw"];
            };
            # "Wikipedia (en)".metaData.alias = "@wiki";
            # "Google".metaData.hidden = true;
            # "Amazon.com".metaData.hidden = true;
            # "Bing".metaData.hidden = true;
            # "eBay".metaData.hidden = true;
          };
        };

        settings = {
          # Smooth scroll
          "general.smoothScroll" = true;

          # Force using WebRender. Improve performance
          "gfx.webrender.all" = true;
          "gfx.webrender.enabled" = true;

          # https://wiki.archlinux.org/title/firefox#Hardware_video_acceleration
          "media.ffmpeg.vaapi.enabled" = true;
          "media.ffvpx.enabled" = false;

          # Enable multi-pip
          "media.videocontrols.picture-in-picture.allow-multiple" = true;

          # Misc
          "browser.disableResetPrompt" = true;
          "browser.aboutConfig.showWarning" = false;
          "browser.tabs.warnOnClose" = false;
          "widget.use-xdg-desktop-portal" = true;
          "ui.context_menus.after_mouseup" = true;
          "browser.toolbars.bookmarks.visibility" = "always";

          # Tab
          "browser.urlbar.suggest.quickactions" = false;
          "browser.urlbar.suggest.topsites" = false;
        };

        extraConfig = ''
          user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
          user_pref("full-screen-api.ignore-widgets", true);
          user_pref("media.ffmpeg.vaapi.enabled", true);
          user_pref("media.rdd-vpx.enabled", true);
        '';

        userChrome = import ./userChrome-css.nix;
        userContent = import ./userContent-css.nix;
      };
      plex = {
        name = "plex";
        id = 3;

        search = {
          force = true;
          default = "google";

          engines = {
            "Youtube" = {
              urls = [
                {
                  template = "https://www.youtube.com/results?search_query={searchTerms}";
                  params = [
                    {
                      name = "type";
                      value = "packages";
                    }
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              definedAliases = ["y"];
            };
            "Nix Packages" = {
              urls = [
                {
                  template = "https://search.nixos.org/packages";
                  params = [
                    {
                      name = "type";
                      value = "packages";
                    }
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              definedAliases = ["np"];
            };
            "NixOS Wiki" = {
              urls = [{template = "https://nixos.wiki/index.php?search={searchTerms}";}];
              iconUpdateURL = "https://nixos.wiki/favicon.png";
              updateInterval = 24 * 60 * 60 * 1000;
              definedAliases = ["nw"];
            };
            # "Wikipedia (en)".metaData.alias = "@wiki";
            # "Google".metaData.hidden = true;
            # "Amazon.com".metaData.hidden = true;
            # "Bing".metaData.hidden = true;
            # "eBay".metaData.hidden = true;
          };
        };

        settings = {
          # Smooth scroll
          "general.smoothScroll" = true;

          # Force using WebRender. Improve performance
          "gfx.webrender.all" = true;
          "gfx.webrender.enabled" = true;

          # https://wiki.archlinux.org/title/firefox#Hardware_video_acceleration
          "media.ffmpeg.vaapi.enabled" = true;
          "media.ffvpx.enabled" = false;

          # Enable multi-pip
          "media.videocontrols.picture-in-picture.allow-multiple" = true;

          # Misc
          "browser.aboutConfig.showWarning" = false;
          "browser.tabs.warnOnClose" = false;
          "widget.use-xdg-desktop-portal" = true;
          "ui.context_menus.after_mouseup" = true;
          "browser.toolbars.bookmarks.visibility" = "always";
          "browser.disableResetPrompt" = true;

          # Tab
          "browser.urlbar.suggest.quickactions" = false;
          "browser.urlbar.suggest.topsites" = false;
        };

        extraConfig = ''
          user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
          user_pref("full-screen-api.ignore-widgets", true);
          user_pref("media.ffmpeg.vaapi.enabled", true);
          user_pref("media.rdd-vpx.enabled", true);
        '';

        userChrome = import ./userChrome-css.nix;
        userContent = import ./userContent-css.nix;
      };
    };
  };
}
