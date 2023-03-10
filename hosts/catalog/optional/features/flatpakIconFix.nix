{
  config,
  lib,
  pkgs,
  ...
}: {
  system.fsPackages = [pkgs.bindfs];
  fileSystems =
    lib.mapAttrs
    (_: v:
      v
      // {
        fsType = "fuse.bindfs";
        options = ["ro" "resolve-symlinks" "x-gvfs-hide"];
      })
    {
      # Create a read-only bind mount of the catppuccin-cursors package to /usr/share/icons
      "/usr/share/icons".device = pkgs.catppuccin-cursors + "/share/icons";
      "/usr/share/fonts".device =
        pkgs.buildEnv
        {
          name = "system-fonts";
          paths = config.fonts.fonts;
          pathsToLink = ["/share/fonts"];
        }
        + "/share/fonts";
    };
}
