{ config, pkgs, ... }:

{
  # Для ноутбуков Lenovo - предотвращает throttling
  services.throttled.enable = true;

  # for SSD
  services.smartd.enable = true;
  services.fstrim.enable = true;
}
