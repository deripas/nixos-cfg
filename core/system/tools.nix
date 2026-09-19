{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    evtest
    libinput
    libsecret
    pkg-config
    git
    mc
    tree
    jq
    yq-go
    wget
    curl
    htop
    btop
    pciutils
    usbutils
    binutils
    unzip
    fastfetch
    killall
    lnav
    lazyjournal
    smartmontools
    libheif
    exiftool
    (ffmpeg-full.override { withUnfree = true; })
  ];

}
