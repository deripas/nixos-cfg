{ config, pkgs, ... }:

{
  services.desktopManager.plasma6.enable = true;

  services.displayManager = {
    sddm.enable = true;
    sddm.wayland.enable = true;

    autoLogin = {
      enable = true;
      user = "anton";
    };
  };

  programs.dconf.enable = true;
  programs.kdeconnect.enable = true;

  # Включаем порталы для интеграции приложений (Flatpak, Snap) с рабочим столом.
  # Это нужно для диалогов открытия/сохранения файлов, тем оформления и т.д.
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = [
      pkgs.kdePackages.xdg-desktop-portal-kde
      pkgs.xdg-desktop-portal-gtk
    ];
  };

  # Для Wayland сессии рекомендуется включить.
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  environment.systemPackages = with pkgs.kdePackages; [
    phonon-vlc
    kate
    kcalc
    konsole
    kolourpaint
    ksystemlog
    ktorrent
    filelight
    partitionmanager
  ];

}
