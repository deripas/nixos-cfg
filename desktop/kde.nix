{ config, pkgs, ... }:

{
  # Включаем KDE Plasma 6.
  services.desktopManager.plasma6.enable = true;
  
  # Включаем SDDM (Display Manager) для входа в систему.
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;

  services.displayManager.autoLogin = {
    enable = true;
    user = "anton";
  };
  
  # Xserver
  services.xserver.enable = true;

  # Настройки раскладки клавиатуры.
  services.xserver.xkb = {
    layout = "us,ru";
    options = "grp:alt_shift_toggle";
  };

  programs.dconf.enable = true;

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
    kate
    konsole
    filelight
    partitionmanager
  ];

}
