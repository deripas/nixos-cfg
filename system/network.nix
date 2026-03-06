{ config, pkgs, ... }:

{
#  networking.enableIPv6 = false;

  # Включаем NetworkManager для управления сетевыми подключениями.
  networking.networkmanager.enable = true;
  networking.networkmanager.settings = {
    main = {
      dhcp = "internal";
    };
    connectivity = {
      enabled = true;
      uri = "http://nmcheck.gnome.org/check_network_status.txt";
      interval = 300;
    };
    connection = {
      autoconnect-retries = 0;
    };
  };

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
