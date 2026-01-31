{ config, pkgs, ... }:

{
  # Включаем Steam.
  programs.steam.enable = true;

  # Добавляем полезные утилиты для игр.
  environment.systemPackages = with pkgs; [
    gamemode # Утилита для оптимизации производительности в играх
    gamescope # композитор
    #proton-caller # Удобный запуск Proton-игр вне Steam
  ];

#   # Для работы Proton могут потребоваться дополнительные библиотеки.
#   # Этот набор покрывает большинство зависимостей.
#   programs.steam.extraCompatPackages = with pkgs; [
#     steam-proton-vr
#     # Добавьте другие, если потребуется
#   ];
}
