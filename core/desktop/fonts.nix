{ pkgs, ... }:

{
  fonts = {
    enableDefaultPackages = true;
    fontDir.enable = true;

    packages = with pkgs; [
      meslo-lgs-nf
      font-awesome
      cascadia-code

      # noto шрифты
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji

      # Полезные Nerd Fonts для терминала и IDE
      nerd-fonts.fira-code
      nerd-fonts.jetbrains-mono
      nerd-fonts.hack
      nerd-fonts.iosevka

      # Системные и UI шрифты
      liberation_ttf
      inter
      roboto
      dejavu_fonts
      corefonts
      vista-fonts
    ];

    # Опционально: базовые фоллбэки по умолчанию
    fontconfig.defaultFonts = {
      serif = [ "Noto Serif" "Liberation Serif" ];
      sansSerif = [ "Inter" "Roboto" "Noto Sans" ];
      monospace = [ "JetBrainsMono Nerd Font" "FiraCode Nerd Font" ];
      emoji = [ "Noto Color Emoji" ];
    };
  };
}
