{
  pkgs,
  config,
  ...
}: {
  # catppuccin = {
  #   enable = true;

  #   flavor = "mocha";
  #   accent = "mauve";

  #   # icon.enable = true;
  #   # icon.accent = "mocha";
  #   # icon.flavor = "mauve";
  # };

  gtk = {
    enable = true;

    theme = {
      name = "Catppuccin-Latte-Standard-Mauve-Light";
      package = pkgs.catppuccin-gtk.override {
        accents = ["mauve"];
        size = "standard";
        tweaks = ["rimless"];
        variant = "mocha";
      };
    };

    iconTheme = {
      name = "Papirus";
      package = pkgs.catppuccin-papirus-folders.override {
        flavor = "mocha";
        accent = "mauve";
      };
    };

    font = {
      name = "Inter";
      size = 13;
    };

    gtk3.extraConfig = {
      gtk-xft-antialias = 1;
      gtk-xft-hinting = 1;
      gtk-xft-hintstyle = "hintslight";
      gtk-xft-rgba = "rgb";
      gtk-decoration-layout = "menu:";
    };

    gtk2.extraConfig = ''
      gtk-xft-antialias=1
      gtk-xft-hinting=1
      gtk-xft-hintstyle="hintslight"
      gtk-xft-rgba="rgb"
    '';
  };

  qt = {
    enable = true;
    # platformTheme = "gnome";
    platformTheme = {
      name = "kvantum";
    };
    style = {
      name = "kvantum";
    };
  };

  home.pointerCursor = {
    # name = "catppuccin-mocha-mauve-cursors";
    name = "catppuccin-mocha-dark-cursors";
    package = pkgs.catppuccin-cursors.mochaMauve;
    size = 28;
    gtk.enable = true;
  };

  home.sessionVariables = {
    # Theming Related Variables
    GTK_THEME = "catppuccin-latte-standard-mauve-light";
    XCURSOR_SIZE = "28";
  };

  xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-gtk];
}
