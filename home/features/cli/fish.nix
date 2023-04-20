{pkgs, ...}: {
  programs.fish = {
    enable = true;
    shellAbbrs = {
    };
    shellAliases = {
      gpgFrontend = "QT_QPA_PLATFORM=\"wayland;xcb\" appimage-run /home/gogsaan/Applications/appimage/GpgFrontend-2.0.9-linux-x86_64_4a0a7c2d621c582a773f4a7652633cc3.AppImage";
      lightDark = "if grep -q 'Catppuccin-Mocha-Standard-Mauve-Dark' /home/gogsaan/Projects/nix/config/home/features/desktop/common/wayland/gtk.nix; sed -i 's/Catppuccin-Mocha-Standard-Mauve-Dark/Catppuccin-Latte-Standard-Mauve-Light/g' /home/gogsaan/Projects/nix/config/home/features/desktop/common/wayland/gtk.nix; else if grep -q 'Catppuccin-Latte-Standard-Mauve-Light' /home/gogsaan/Projects/nix/config/home/features/desktop/common/wayland/gtk.nix; sed -i 's/Catppuccin-Latte-Standard-Mauve-Light/Catppuccin-Mocha-Standard-Mauve-Dark/g' /home/gogsaan/Projects/nix/config/home/features/desktop/common/wayland/gtk.nix; end; and echo \"Check Yubikey\" && sudo nixos-rebuild switch --flake /home/gogsaan/Projects/nix/config#gza --show-trace";
      tuivpnon = "nmcli radio wifi on || true && sleep 5 && echo \"Check Yubikey\" && sudo nmcli device disconnect enp38s0 || true  && nmcli device connect wlo1 || true && nmcli device connect enp38s0 || true && sudo ip route add 10.141.96.190/32 via 192.168.137.1 dev wlo1 && sudo ip route add 10.141.96.117/32 via 192.168.137.1 dev wlo1";
      tuivpnoff = "nmcli radio wifi off";
      yarn = "npm run";
      npmr = "npm run";
      cleanup = "sudo nix-collect-garbage --delete-older-than 7d";
      bloat = "nix path-info -Sh /run/current-system";
      cat = "${pkgs.bat}/bin/bat --style=plain";
      nb = "echo \"Check Yubikey\" && sudo rm /home/gogsaan/.config/mimeapps.list || true && sudo rm /home/gogsaan/.ssh/config || true && git add . || true && sudo nixos-rebuild switch --flake /home/gogsaan/Projects/nix/config#gza --show-trace";
      nu = "echo \"Check Yubikey\" && sudo nix flake update";
      sops = "nix-shell -p sops --run \" sops hosts/catalog/secrets.yaml \"";
      ls = "exa";
      cdd = "cd $(find ~ -type d | fzf)";
      la = "${pkgs.exa}/bin/exa -lah";
      getip = "curl ifconfig.me";
      ssh = "kitty +kitten ssh";
      k9s = "k9s --kubeconfig $KUBECONFIG";
      kubectl = "kubectl --kubeconfig $KUBECONFIG";
      kubefwd = "echo \"Check Yubikey\" && sudo cp /etc/hosts /etc/hostsTemp && sudo rm /etc/hosts && sudo cp /etc/hostsTemp /etc/hosts && sudo ~/Applications/bin/kubefwd svc -c $KUBECONFIG -n crawlyfi-prod";
      # Clear screen and scrollback
      clear = "printf '\\033[2J\\033[3J\\033[1;1H'";
      startCoder = "nohup /home/gogsaan/Applications/bin/coder server --postgres-url \"postgres://coder:coder@127.0.0.1:5432/coder?sslmode=disable\" --derp-config-url https://controlplane.tailscale.com/derpmap/default & && disown ";
      protonge = "protonup -d \"/home/gogsaan/.steam/steam/compatibilitytools.d\" && protonup ";
    };
    functions = {
      fish_greeting = "";
      wh = "readlink -f (which $argv)";
    };
    interactiveShellInit =
      # Open command buffer in vim when alt+e is pressed
      ''
        bind \ee edit_command_buffer
        bind \cr true
      ''
      +
      # kitty integration
      ''
        set --global KITTY_INSTALLATION_DIR "${pkgs.kitty}/lib/kitty"
        set --global KITTY_SHELL_INTEGRATION enabled
        source "$KITTY_INSTALLATION_DIR/shell-integration/fish/vendor_conf.d/kitty-shell-integration.fish"
        set --prepend fish_complete_path "$KITTY_INSTALLATION_DIR/shell-integration/fish/vendor_completions.d"
      ''
      +
      # Use vim bindings and cursors
      ''
        # fish_vi_key_bindings
        # set fish_cursor_default     block      blink
        # set fish_cursor_insert      line       blink
        # set fish_cursor_replace_one underscore blink
        # set fish_cursor_visual      block
      ''
      +
      # Use terminal colors
      ''
        set -U fish_color_autosuggestion      brblack
        set -U fish_color_cancel              -r
        set -U fish_color_command             brgreen
        set -U fish_color_comment             brmagenta
        set -U fish_color_cwd                 green
        set -U fish_color_cwd_root            red
        set -U fish_color_end                 brmagenta
        set -U fish_color_error               brred
        set -U fish_color_escape              brcyan
        set -U fish_color_history_current     --bold
        set -U fish_color_host                normal
        set -U fish_color_match               --background=brblue
        set -U fish_color_normal              normal
        set -U fish_color_operator            cyan
        set -U fish_color_param               brblue
        set -U fish_color_quote               yellow
        set -U fish_color_redirection         bryellow
        set -U fish_color_search_match        'bryellow' '--background=brblack'
        set -U fish_color_selection           'white' '--bold' '--background=brblack'
        set -U fish_color_status              red
        set -U fish_color_user                brgreen
        set -U fish_color_valid_path          --underline
        set -U fish_pager_color_completion    normal
        set -U fish_pager_color_description   yellow
        set -U fish_pager_color_prefix        'white' '--bold' '--underline'
        set -U fish_pager_color_progress      'brwhite' '--background=cyan'
        starship init fish | source

        set -U -x KUBECONFIG /home/gogsaan/Projects/crawlyfi/terraform/kubernetes/kubeconfig
        set PATH $HOME/.npm/bin $fish_user_paths $PATH

        set -U -x CRAWLYFI_ENV dev
      '';
  };

  home = {
    persistence = {
      "/persist/home/gogsaan" = {
        allowOther = true;
        files = [
          ".local/share/fish/fish_history"
        ];
      };
    };
  };
}
