{
  pkgs,
  config,
  ...
}: {
  # gtk = {
  #   enable = true;
  #   theme = {
  #     name = "Catppuccin-Latte-Standard-Mauve-Light";
  #     package = pkgs.catppuccin-gtk;
  #   };

  #   # iconTheme = {
  #   #   name = "Papirus";
  #   #   package = pkgs.catppuccin-folders;
  #   # };

  #   font = {
  #     name = "Inter";
  #     size = 13;
  #   };

  #   gtk3.extraConfig = {
  #     gtk-xft-antialias = 1;
  #     gtk-xft-hinting = 1;
  #     gtk-xft-hintstyle = "hintslight";
  #     gtk-xft-rgba = "rgb";
  #     gtk-decoration-layout = "menu:";
  #   };

  #   gtk2.extraConfig = ''
  #     gtk-xft-antialias=1
  #     gtk-xft-hinting=1
  #     gtk-xft-hintstyle="hintslight"
  #     gtk-xft-rgba="rgb"
  #   '';
  # };

  gtk = {
    enable = true;
    theme = {
      name = "Catppuccin-Mocha-Standard-Mauve-dark";
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
    platformTheme = "gnome";
    style = {
      package = pkgs.adwaita-qt;
      name = "adwaita-dark";
    };
  };

  home.pointerCursor = {
    name = "Catppuccin-Mocha-Mauve-Cursors";
    package = pkgs.catppuccin-cursors.mochaMauve;
    size = 28;
    gtk.enable = true;
  };

  home.sessionVariables = {
    # Theming Related Variables
    GTK_THEME = "Catppuccin-Latte-Standard-Mauve-Light";
    XCURSOR_SIZE = "28";
  };
}
