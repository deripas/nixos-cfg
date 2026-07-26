{ config, pkgs, ... }:

{
  # Avahi (mDNS / IPP discovery) для автоматического обнаружения принтеров и других сервисов.
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
}
