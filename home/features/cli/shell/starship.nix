{config, ...}: {
  programs.starship = {
    enable = true;
    settings = {
      scan_timeout = 10;
      add_newline = true;
      line_break.disabled = true;
      cmd_duration.disabled = false;

      format = let
        git = "$git_branch$git_metrics$git_commit$git_state$git_status";
      in ''
        [](#9A348E)$os$username[](bg:#DA627D fg:#9A348E)$directory[](fg:#DA627D bg:#FCA17D)$git_branch$git_status[](fg:#FCA17D bg:#86BBD8)$c$elixir$elm$golang$haskell$java$julia$nodejs$nim$rust$scala[](fg:#86BBD8 bg:#33658A)$time[ ](fg:#33658A)
      '';

      right_format = "$status";

      username = {
        show_always = true;
        style_user = "bold #000000 bg:#9A348E";
        style_root = "bold #000000 bg:#9A348E";
        format = "[λ ]($style)";
        disabled = false;
      };

      os = {
        style = "bg:#9A348E";
        disabled = true;
      };
      character = {
        success_symbol = "[λ](green)";
        error_symbol = "[λ](red)";
      };

      directory = {
        style = "#000000 bg:#DA627D";
        format = "[ $path ]($style)";
        truncation_length = 1;
        truncation_symbol = "…/";
        read_only = " ";
      };

      time = {
        disabled = false;
        time_format = "%R"; # Hour:Minute Format
        style = "bg:#33658A";
        format = "[ ♥ ]($style)";
      };

      status = {
        format = "[$symbol]($style)";
        symbol = "[](red)";
        success_symbol = "[](green)";
        disabled = false;
      };

      git_branch = {
        symbol = "";
        style = "#000000 bg:#FCA17D";
        format = "[ $symbol $branch ]($style)";
      };

      git_metrics = {
        symbol = "";
        style = "#000000 bg:#FCA17D";
        format = "[ $symbol $branch ]($style)";
      };

      git_status = {
        style = "#000000 bg:#FCA17D";
        format = "[$all_status$ahead_behind ]($style)";
      };

      aws.symbol = "  ";
      conda.symbol = " ";
      dart.symbol = " ";
      docker_context = {
        symbol = " ";
        style = "#000000 bg:#86BBD8";
      };
      elixir.symbol = " ";
      elm.symbol = " ";
      gcloud.symbol = " ";
      golang = {
        symbol = " ";
        style = "#000000 bg:#86BBD8";
      };
      java = {
        symbol = " ";
        style = "#000000 bg:#86BBD8";
      };
      julia.symbol = " ";
      lua.symbol = " ";
      memory_usage.symbol = " ";
      nim.symbol = " ";

      nix_shell = {
        symbol = " ";
        style = "#000000 bg:#86BBD8";
      };

      nodejs = {
        symbol = " ";
        style = "#000000 bg:#86BBD8";
        format = "[ $symbol $version ]($style)";
      };

      package = {
        symbol = " ";
        style = "#000000 bg:#86BBD8";
      };
      perl.symbol = " ";
      php.symbol = " ";
      python = {
        symbol = " ";
        style = "#000000 bg:#86BBD8";
      };
      ruby.symbol = " ";
      rust.symbol = " ";
      scala.symbol = " ";
      swift.symbol = "ﯣ ";
      terraform = {
        symbol = "行 ";
        style = "#000000 bg:#86BBD8";
      };
    };
  };
}
