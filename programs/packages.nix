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
    binutils
    unzip
    neofetch
    nodejs_24
    go
    # ((pkgs.ffmpeg-full.override { withUnfree = true; }).overrideAttrs (_: { doCheck = false; }))
    killall
  ];

}
