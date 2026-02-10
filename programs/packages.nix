{ config, pkgs, ... }:

{
  # Разрешаем установку несвободных пакетов.
  nixpkgs.config = {
    allowUnfree = true;
    allowBroken = false;
  };

  # Основные системные пакеты.
  environment.systemPackages = with pkgs; [
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
    unzip
    neofetch
    nodejs_24
    go
    ffmpeg-full
  ];

}
