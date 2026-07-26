{ config, pkgs, ... }:

{
  services.power-profiles-daemon.enable = true;
  services.thermald.enable = true;

  # Для ноутбуков Lenovo - предотвращает throttling
  services.throttled.enable = true;
}