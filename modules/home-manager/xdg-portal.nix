{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit
    (lib)
    mapAttrsToList
    mkEnableOption
    mkIf
    mkMerge
    mkOption
    optional
    optionalString
    types
    ;

  associationOptions = with types;
    attrsOf (coercedTo (either (listOf str) str)
      (x: lib.concatStringsSep ";" (lib.toList x))
      str);
in {
  meta.maintainers = [lib.maintainers.misterio77];

  options.xdg.portal = {
    enable =
      mkEnableOption (lib.mdDoc
        "[xdg desktop integration](https://github.com/flatpak/xdg-desktop-portal)")
      // {
        default = false;
      };

    extraPortals = mkOption {
      type = types.listOf types.package;
      default = [];
      description = lib.mdDoc ''
        List of additional portals to add to path. Portals allow interaction
        with system, like choosing files or taking screenshots. At minimum,
        a desktop portal implementation should be listed. GNOME and KDE already
        adds `xdg-desktop-portal-gtk`; and
        `xdg-desktop-portal-kde` respectively. On other desktop
        environments you probably want to add them yourself.
      '';
    };

    gtkUsePortal = mkOption {
      type = types.bool;
      visible = false;
      default = false;
      description = lib.mdDoc ''
        Sets environment variable `GTK_USE_PORTAL` to `1`.
        This will force GTK-based programs ran outside Flatpak to respect and use XDG Desktop Portals
        for features like file chooser but it is an unsupported hack that can easily break things.
        Defaults to `false` to respect its opt-in nature.
      '';
    };

    xdgOpenUsePortal = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Sets environment variable `NIXOS_XDG_OPEN_USE_PORTAL` to `1`
        This will make `xdg-open` use the portal to open programs, which resolves bugs involving
        programs opening inside FHS envs or with unexpected env vars set from wrappers.
        See [#160923](https://github.com/NixOS/nixpkgs/issues/160923) for more info.
      '';
    };

    config = mkOption {
      type = types.attrsOf associationOptions;
      default = {};
      example = {
        x-cinnamon = {default = ["xapp" "gtk"];};
        pantheon = {
          default = ["pantheon" "gtk"];
          "org.freedesktop.impl.portal.Secret" = ["gnome-keyring"];
        };
        common = {default = ["gtk"];};
      };
      description = lib.mdDoc ''
        Sets which portal backend should be used to provide the implementation
        for the requested interface. For details check {manpage}`portals.conf(5)`.

        Configs will be linked to `/etx/xdg/xdg-desktop-portal/` with the name `$desktop-portals.conf`
        for `xdg.portal.config.$desktop` and `portals.conf` for `xdg.portal.config.common`
        as an exception.
      '';
    };

    configPackages = mkOption {
      type = types.listOf types.package;
      default = [];
      example = lib.literalExpression "[ pkgs.gnome.gnome-session ]";
      description = lib.mdDoc ''
        List of packages that provide XDG desktop portal configuration, usually in
        the form of `share/xdg-desktop-portal/$desktop-portals.conf`.

        Note that configs in `xdg.portal.config` will be preferred if set.
      '';
    };
  };

  config = let
    cfg = config.xdg.portal;

    joinedPortals = pkgs.buildEnv {
      name = "xdg-portals";
      paths = cfg.extraPortals;
      pathsToLink = ["/share/xdg-desktop-portal/portals" "/share/applications"];
    };

    portalConfigPath = n: "share/xdg-desktop-portal/${
      optionalString (n != "common") "${n}-"
    }portals.conf";
    mkPortalConfig = desktop: conf:
      pkgs.writeTextDir (portalConfigPath desktop)
      (lib.generators.toINI {} {preferred = conf;});

    joinedPortalConfigs = pkgs.buildEnv {
      name = "xdg-portal-configs";
      ignoreCollisions = true; # Let config override configPackages cfgs
      paths = (mapAttrsToList mkPortalConfig cfg.config) ++ cfg.configPackages;
      pathsToLink = ["/share/xdg-desktop-portal"];
    };
  in
    mkIf cfg.enable (mkMerge [
      {
        warnings = optional (cfg.configPackages == [] && cfg.config == {}) ''
          xdg-desktop-portal 1.17 reworked how portal implementations are loaded, you
          should either set `xdg.portal.config` or `xdg.portal.configPackages`
          to specify which portal backend to use for the requested interface.

          https://github.com/flatpak/xdg-desktop-portal/blob/1.18.1/doc/portals.conf.rst.in

          If you simply want to keep the behaviour in < 1.17, which uses the first
          portal implementation found in lexicographical order, use the following:

          xdg.portal.config.common.default = "*";
        '';

        assertions = [
          {
            assertion = cfg.extraPortals != [];
            message = "Setting xdg.portal.enable to true requires a portal implementation in xdg.portal.extraPortals such as xdg-desktop-portal-gtk or xdg-desktop-portal-kde.";
          }
        ];

        # Make extraPortals systemd units available to the user
        home.packages = [pkgs.xdg-desktop-portal] ++ cfg.extraPortals;

        systemd.user.services.xdg-desktop-portal = {
          Unit = {
            Description = "Portal service";
            PartOf = "graphical-session.target";
          };
          Service = {
            Environment =
              [
                "XDG_DESKTOP_PORTAL_DIR=${joinedPortals}/share/xdg-desktop-portal/portals"
              ]
              ++ (optional (cfg.configPackages != [])
                "NIXOS_XDG_DESKTOP_PORTAL_CONFIG_DIR=${joinedPortalConfigs}/share/xdg-desktop-portal");
            Type = "dbus";
            BusName = "org.freedesktop-portal.Desktop";
            ExecStart = "${pkgs.xdg-desktop-portal}/libexec/xdg-desktop-portal";
            Slice = "session.slice";
          };
        };
      }
      # This module uses mkMerge because HM's home.sessionVariables are (at the
      # time of writing) scalars, which do not work with mkIf
      (mkIf cfg.gtkUsePortal {home.sessionVariables.GTK_USE_PORTAL = "1";})
      (mkIf cfg.xdgOpenUsePortal {
        home.sessionVariables.NIXOS_XDG_OPEN_USE_PORTAL = "1";
      })
    ]);
}
