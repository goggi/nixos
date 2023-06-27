{
  inputs,
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    playerctl # for media keys
    deepin.deepin-calculator
    steam-tui
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
