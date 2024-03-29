{
  inputs,
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    libdrm
    audio-recorder
    libreoffice-fresh
    easyeffects
    kooha
    s3fs
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
