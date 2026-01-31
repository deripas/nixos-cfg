{ pkgs, ... }:

{
  # Установка шрифтов в систему.
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    liberation_ttf
  ];

  # Для лучшего рендеринга шрифтов можно раскомментировать:
  # fonts.fontconfig.enable = true;
  # fonts.fontconfig.defaultFonts = {
  #   serif = [ "Noto Serif" ];
  #   sansSerif = [ "Noto Sans" ];
  #   monospace = [ "FiraCode Nerd Font Mono" ];
  # };
}
