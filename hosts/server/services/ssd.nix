{ config, pkgs, ... }:

{
  # for SSD
  services.smartd.enable = true;
  services.fstrim.enable = true;
}
