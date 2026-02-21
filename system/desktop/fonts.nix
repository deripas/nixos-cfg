{ pkgs, ... }:

{
  # Установка шрифтов в систему.
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    liberation_ttf
    font-awesome
    meslo-lgs-nf
  ];

}
