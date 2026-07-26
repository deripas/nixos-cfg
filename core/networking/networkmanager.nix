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
}
