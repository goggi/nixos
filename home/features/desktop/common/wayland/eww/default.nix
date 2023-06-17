{
  inputs,
  pkgs,
  config,
  ...
}: {
  # eww package
  home.packages = with pkgs; [
    eww-wayland
    pamixer
    brightnessctl
    (nerdfonts.override {fonts = ["JetBrainsMono"];})
  ];

  # configuration
  home.file.".config/eww/eww.scss".source = ./eww.scss;
  home.file.".config/eww/eww.yuck".source = ./eww.yuck;
  home.file.".config/eww/launch_bar" = {
    source = ./launch_bar;
    executable = true;
  };

  # images
  home.file.".config/eww/images/mic.png".source = ./images/mic.png;
  home.file.".config/eww/images/music.png".source = ./images/music.png;
  home.file.".config/eww/images/profile.png".source = ./images/profile.png;
  home.file.".config/eww/images/speaker.png".source = ./images/speaker.png;

  # scripts
  home.file.".config/eww/scripts/battery" = {
    source = ./scripts/battery;
    executable = true;
  };

  home.file.".config/eww/scripts/mem-ad" = {
    source = ./scripts/mem-ad;
    executable = true;
  };

  home.file.".config/eww/scripts/memory" = {
    source = ./scripts/memory;
    executable = true;
  };

  home.file.".config/eww/scripts/music_info" = {
    source = ./scripts/music_info;
    executable = true;
  };

  home.file.".config/eww/scripts/pop" = {
    source = ./scripts/pop;
    executable = true;
  };

  home.file.".config/eww/scripts/wifi" = {
    source = ./scripts/wifi;
    executable = true;
  };

  home.file.".config/eww/scripts/workspace" = {
    source = ./scripts/workspace;
    executable = true;
  };
}
