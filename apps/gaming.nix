{ config, pkgs, ... }:

{
  # Включаем Steam.
  programs.steam.enable = true;

  # Добавляем полезные утилиты для игр.
  environment.systemPackages = with pkgs; [
    gamemode
    gamescope
    wine
    winetricks
    lutris
  ];

}
