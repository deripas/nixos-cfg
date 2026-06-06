{ config, pkgs, ... }:

{
  # Разрешаем установку несвободных пакетов.
  nixpkgs.config = {
    allowUnfree = true;
    allowBroken = false;
  };

  # Основные системные пакеты.
  environment.systemPackages = with pkgs; [
    evtest
    libinput
    git
    vim
    neovim
    mc
    tree
    jq
    wget
    curl
    htop
    btop
    pciutils
    usbutils
    binutils
    unzip
    fastfetch
    nodejs_24
    go
    killall
    vlc
    lnav
    lazyjournal
    ghostty
    kitty
  ];

}
