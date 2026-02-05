{ config, pkgs, ... }:

{
  # Enable CUPS to print documents.
  services.printing = {
    enable = true;
    drivers = [ pkgs.gutenprint ];
  };

  # Включаем поддержку Flatpak.
  services.flatpak.enable = true;

  # Avahi (mDNS / IPP discovery) для автоматического обнаружения принтеров и других сервисов.
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
}
