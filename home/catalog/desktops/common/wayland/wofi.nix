{
  config,
  lib,
  pkgs,
  ...
}: let
  wofi = pkgs.wofi.overrideAttrs (oa: {
    patches =
      (oa.patches or [])
      ++ [
        ./wofi-run-shell.patch # Fix for https://todo.sr.ht/~scoopta/wofi/174
      ];
  });

  pass = config.programs.password-store.package;
  passEnabled = config.programs.password-store.enable;
  pass-wofi = pkgs.pass-wofi.override {inherit pass;};
in {
  home.packages =
    [wofi]
    ++ (lib.optional passEnabled pass-wofi);

  xdg.configFile."wofi/config".text = ''
    mode=run
    insensitive=true
    prompt=
    width=500
    height=400
    term=kitty
    hide_scroll=true
    # location=2
    # yoffset=50
    run-always_parse_args=true
    run-cache_file=/dev/null
    run-exec_search=true
  '';

  xdg.configFile."wofi/style.css".text = ''
      * {
        bg-col:  #24273a;
        bg-col-light: #24273a;
        border-col: #24273a;
        selected-col: #24273a;
        blue: #8aadf4;
        fg-col: #cad3f5;
        fg-col2: #ed8796;
        grey: #6e738d;

        width: 600;
        font: "JetBrainsMono Nerd Font 14";
    }

    element-text, element-icon , mode-switcher {
        background-color: inherit;
        text-color:       inherit;
    }

    window {
        height: 360px;
        border: 3px;
        border-color: @border-col;
        background-color: @bg-col;
    }

    mainbox {
        background-color: @bg-col;
    }

    inputbar {
        children: [prompt,entry];
        background-color: @bg-col;
        border-radius: 5px;
        padding: 2px;
    }

    prompt {
        background-color: @blue;
        padding: 6px;
        text-color: @bg-col;
        border-radius: 3px;
        margin: 20px 0px 0px 20px;
    }

    textbox-prompt-colon {
        expand: false;
        str: ":";
    }

    entry {
        padding: 6px;
        margin: 20px 0px 0px 10px;
        text-color: @fg-col;
        background-color: @bg-col;
    }

    listview {
        border: 0px 0px 0px;
        padding: 6px 0px 0px;
        margin: 10px 0px 0px 20px;
        columns: 2;
        lines: 5;
        background-color: @bg-col;
    }

    element {
        padding: 5px;
        background-color: @bg-col;
        text-color: @fg-col  ;
    }

    element-icon {
        size: 25px;
    }

    element selected {
        background-color:  @selected-col ;
        text-color: @fg-col2  ;
    }

    mode-switcher {
        spacing: 0;
      }

    button {
        padding: 10px;
        background-color: @bg-col-light;
        text-color: @grey;
        vertical-align: 0.5;
        horizontal-align: 0.5;
    }

    button selected {
      background-color: @bg-col;
      text-color: @blue;
    }

    message {
        background-color: @bg-col-light;
        margin: 2px;
        padding: 2px;
        border-radius: 5px;
    }

    textbox {
        padding: 6px;
        margin: 20px 0px 0px 20px;
        text-color: @blue;
        background-color: @bg-col-light;
    }

  '';
}
