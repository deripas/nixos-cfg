{ config, pkgs, ... }:

{
  services.immich = {
    enable = true;
    port = 2283;
    host = "0.0.0.0";
    mediaLocation = "/home/services/immich";
    openFirewall = true;

    database.enable = true;
    database.host = "/run/postgresql";
    database.name = "immich";
  };
}
