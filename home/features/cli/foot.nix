{
  config,
  pkgs,
  ...
}: {
  programs.foot = {
    enable = true;
    settings = {
      main = {
        term = "xterm-256color";
        pad = "30x30";
        font = "monospace:size=12";
        dpi-aware = "yes";
      };

      colors = {
        alpha = "0.9";
        foreground = "CDD6F4";
        background = "1E1E2E";
        regular0 = "20262c";
        regular1 = "db86ba";
        regular2 = "74dd91";
        regular3 = "e49186"; # yellow
        regular4 = "75dbe1"; # blue
        regular5 = "b4a1db"; # magenta
        regular6 = "9ee9ea"; # cyan
        regular7 = "f1fcf9"; # white
      };
    };
  };
}
