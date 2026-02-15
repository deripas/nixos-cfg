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
}

