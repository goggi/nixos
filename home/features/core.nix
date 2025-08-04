{
  inputs,
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    satty
    wl-clipboard
    uv
    pigz
    ffmpeg
    sqlite
    jdk23
    graphviz
    bazecor
    kopia
    sox
    ncdu
    nixfmt-classic
    # pulumi
    # pulumi-bin
    # pulumiPackages.pulumi-language-nodejs
    # deepin.deepin-calculator
    libdrm
    audio-recorder
    # libreoffice-fresh
    easyeffects
    kooha
    lzip
    playerctl # for media keys
    steamtinkerlaunch
    vlc
    # leafpad
    envsubst
    lsof
    gh
    bindfs
    networkmanager-openvpn
    appimage-run
    ddcutil
    alsa-lib
    xorg.xlsclients
    alsa-plugins
    alsa-tools
    alsa-utils
    bandwhich
    bc
    bash
    blueberry
    cached-nix-shell
    coreutils
    dconf
    findutils
    fzf
    glib
    nano
    inotify-tools
    killall
    libappindicator
    libnotify
    libsecret
    cmake
    pamixer
    pavucontrol
    rsync
    util-linux
    wirelesstools
    xarchiver
    xclip
    xdg-utils
    xh
    xorg.xhost
  ];
}
