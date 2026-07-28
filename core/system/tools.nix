{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    evtest
    libinput
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
  ];

}
