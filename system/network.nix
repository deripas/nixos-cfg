{ config, pkgs, ... }:

{
  # Имя хоста.
  networking.hostName = "korsar"; # Вы можете изменить его здесь.

  # Включаем NetworkManager для управления сетевыми подключениями.
  networking.networkmanager.enable = true;

  # Настройки файрвола.
  networking.firewall = {
    enable = true;
    # Открываем порты для mDNS (обнаружение устройств в сети, например, принтеров).
    allowedUDPPorts = [ 5353 ]; 
    allowedTCPPorts = [ ];
  };

  # Avahi (mDNS / IPP discovery) для автоматического обнаружения принтеров и других сервисов.
  services.avahi = {
    enable = true;
    nssmdns4 = true; # Для IPv4
    openFirewall = true; # Автоматически открывает порты в файрволе.
  };
}
