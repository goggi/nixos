{
  inputs,
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    # firefox-devedition-bin-unwrapped
    deepin.deepin-calculator
    terraform
    # archi
    # xwaylandvideobridge
    playerctl
    vlc
    leafpad
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
    cinnamon.nemo
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
