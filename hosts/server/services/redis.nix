{ config, pkgs, ... }:

{
  services.redis.servers.immich = {
    enable = true;
    port = 6379;
  };
}
