{
  config,
  pkgs,
  ...
}: let
  power-menu = pkgs.writeShellScriptBin "power-menu" ''
    #!/bin/sh

    shutdown="襤"
    reboot="ﰇ"
    cancel=""

    rofi_cmd() {
      killall rofi || rofi -dmenu -p "Power Menu" -theme power
    }

    run_rofi() {
      echo -e "$shutdown\n$reboot\n$cancel" | rofi_cmd
    }

    case "$(run_rofi)" in
    	$shutdown)
    		systemctl poweroff
    		;;
    	$reboot)
    		systemctl reboot
    		;;
    esac
  '';
in {
  home.packages = with pkgs; [
    (rofi-wayland.override {
      plugins = [rofi-emoji];
    })
    power-menu
    wl-clipboard
    wtype
  ];

  # xdg.configFile."rofi/colors.rasi".text = ''
  #   * {
  #     background: #181825;
  #     prompt: #1e1e2e;
  #     border: #1e1e2e;
  #     text: #cdd6f4;
  #     select: #1e1e2e;
  #   }
  # '';

  # xdg.configFile."rofi/index.rasi".text = ''
  #   configuration {
  #     modi: "drun,emoji";
  #     display-drun: "Applications";
  #     drun-display-format: "{name}";
  #     font: "Inter 13px";
  #   }

  #   @import "./colors.rasi"

  #   * {
  #     background-color: transparent;
  #     text-color: @text;
  #     margin: 0;
  #     padding: 0;
  #   }

  #   window {
  #     transparency: "real";
  #     location: center;
  #     anchor: center;
  #     fullscreen: false;
  #     width: 21em;
  #     x-offset: 0px;
  #     y-offset: 0px;

  #     enabled: true;
  #     border: 2px solid;
  #     border-color: @border;
  #     border-radius: 8px;
  #     background-color: @background;
  #     cursor: "default";
  #   }

  #   inputbar {
  #     enabled: true;
  #     border: 0 0 1px 0 solid;
  #     border-color: @border;
  #     background-color: @prompt;
  #     orientation: horizontal;
  #     children: [ "entry" ];
  #   }

  #   entry {
  #     enabled: true;
  #     padding: 0.75em 1.25em;
  #     cursor: text;
  #     placeholder: "Search application...";
  #     placeholder-color: @text;
  #   }

  #   listview {
  #     enabled: true;
  #     columns: 1;
  #     lines: 6;
  #     cycle: true;
  #     dynamic: true;
  #     scrollbar: false;
  #     layout: vertical;
  #     reverse: false;
  #     fixed-height: true;
  #     fixed-columns: true;
  #     margin:  0.5em 0 0.75em;
  #     cursor: "default";
  #   }

  #   element {
  #     enabled: true;
  #     margin: 0 0.75em;
  #     padding: 0.5em 1em;
  #     cursor: pointer;
  #     orientation: vertical;
  #   }

  #   element normal.normal {
  #     background-color: inherit;
  #     text-color: inherit;
  #   }

  #   element selected.normal {
  #     border: 2px solid;
  #     border-color: @border;
  #     border-radius: 8px;
  #     background-color: @select;
  #   }

  #   element-text {
  #     highlight: bold;
  #     cursor: inherit;
  #     vertical-align: 0.5;
  #     horizontal-align: 0.0;
  #     font: "Inter Medium 13px";
  #   }
  # '';

  xdg.configFile."rofi/index.rasi".text = ''
        configuration {
        icon-theme: "Oranchelo";
        show-icons: true;
        terminal: "kitty";
        drun-display-format: "{icon} {name}";
        location: 0;
        disable-history: false;
        hide-scrollbar: true;
        display-drun: "   Apps ";
        display-run: "   Run ";
        display-emoji: "   Emoji ";
        display-window: " 﩯  Window";
        display-Network: " 󰤨  Network";
        sidebar-mode: true;
        }
    * {
        bg-col:  #1e1e2e;
        bg-col-light: #1e1e2e;
        border-col: #1e1e2e;
        selected-col: #1e1e2e;
        blue: #89b4fa;
        fg-col: #cdd6f4;
        fg-col2: #f38ba8;
        grey: #6c7086;

        width: 600;
        font: "JetBrainsMono Nerd Font 14";
    }

    element-text, element-icon , mode-switcher {
        background-color: inherit;
        text-color:       inherit;
    }

    window {
        transparency: "real";
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

  xdg.configFile."rofi/emoji.rasi".text = ''
    @theme "index"

    listview {
      columns: 5;
      lines: 4;
      layout: vertical;
      fixed-columns: true;
      margin: 0.5em 0.25em;
      flow: horizontal;
    }

    window {
      width: 19em;
    }

    element {
      padding: 1em;
      margin: 0 0.25em;
    }

    element-text {
      vertical-align: 0.5;
      horizontal-align: 0.5;
    }

    entry {
      placeholder: "Search emoji...";
    }
  '';

  xdg.configFile."rofi/power.rasi".text = ''
    @theme "index"

    * {
      horizontal-align: 0.5;
    }

    window {
      width: 13.5em;
    }

    inputbar {
      children: [ prompt ];
    }

    prompt {
      padding: 0.5em 0.75em;
      font: "Inter 13px";
    }

    listview {
      lines: 3;
      layout: horizontal;
      margin: 0.5em 0.5em 0.75em;
    }

    element {
      padding: 1em 0em;
      margin: 0 0.25em;
      width: 4em;
    }

    element-text {
      font: "monospace Bold 21px";
      vertical-align: 0.5;
      horizontal-align: 0.5;
    }
  '';
}
