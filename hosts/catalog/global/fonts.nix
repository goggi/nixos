{
  pkgs,
  lib,
  ...
}: {
  # fonts = {
  #   packages = lib.attrValues {
  #     inherit
  #       (pkgs)
  #       # emacs-all-the-icons-fonts

  #       lexend
  #       inter
  #       material-icons
  #       material-symbols
  #       material-design-icons
  #       noto-fonts
  #       noto-fonts-cjk
  #       noto-fonts-emoji
  #       sf-mono-liga
  #       twemoji-color-font
  #       ;
  #   };

  #   fontconfig = {
  #     enable = true;
  #     antialias = true;
  #     hinting = {
  #       enable = true;
  #       autohint = true;
  #       style = "full";
  #       # style = "hintfull";
  #     };

  #     subpixel.lcdfilter = "default";

  #     defaultFonts = {
  #       emoji = ["Noto Color Emoji"];
  #       monospace = ["Liga SFMono Nerd Font"];
  #       sansSerif = ["Noto Sans" "Noto Color Emoji"];
  #       serif = ["Noto Serif" "Noto Color Emoji"];
  #     };
  #   };
  # };
  fonts = {
    packages = with pkgs; [
      # icon fonts
      material-symbols

      # normal fonts
      lexend
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      sf-mono-liga
      roboto

      nerd-fonts.fira-code
      nerd-fonts.jetbrains-mono

      # nerdfonts
      # (nerdfonts.override {fonts = ["FiraCode" "JetBrainsMono"];})
      # nerd-fonts
    ];

    # causes more issues than it solves
    enableDefaultPackages = false;

    # user defined fonts
    # the reason there's Noto Color Emoji everywhere is to override DejaVu's
    # B&W emojis that would sometimes show instead of some Color emojis
    fontconfig.defaultFonts = {
      serif = ["Roboto Serif" "Noto Color Emoji"];
      sansSerif = ["Roboto" "Noto Color Emoji"];
      monospace = ["JetBrainsMono Nerd Font" "Noto Color Emoji"];
      emoji = ["Noto Color Emoji"];
    };
  };
}
