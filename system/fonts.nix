{ pkgs, ... }:

{
  # Установка шрифтов в систему.
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    liberation_ttf
  ];

}
