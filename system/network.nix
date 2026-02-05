{ config, pkgs, ... }:

{
  # Включаем NetworkManager для управления сетевыми подключениями.
  networking.networkmanager.enable = true;

  # Настройки файрвола.
  networking.firewall = {
    enable = true;
    # Открываем порты для mDNS (обнаружение устройств в сети, например, принтеров).
    allowedUDPPorts = [ 5353 ];
    allowedUDPPortRanges = [
      { from = 1714; to = 1764; }
    ];
    allowedTCPPortRanges = [
     { from = 1714; to = 1764; }
    ];
  };
}
