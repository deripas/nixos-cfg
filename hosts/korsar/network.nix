{ config, pkgs, ... }:
let
  mkWifi = name: {
    connection = {
      id = name;
      type = "wifi";
      autoconnect = true;
    };
    ipv6.method = "ignore";
  };
in
{
  networking.networkmanager.ensureProfiles.profiles = {
    xiaomi5g = mkWifi "Xiaomi_5G";
    xiaomi24 = mkWifi "Xiaomi";
  };

#  networking.routes = [
#    { address = "10.0.0.0"; prefixLength = 8; via = "10.10.10.195"; }
#    { address = "172.16.0.0"; prefixLength = 12; via = "10.10.10.195"; }
#  ];
}

