{ config, pkgs, ... }:

{
  # Enable CUPS to print documents.
  services.printing = {
    enable = true;
    drivers = [ pkgs.gutenprint ];
  };

  services.power-profiles-daemon.enable = true;

  services.thermald.enable = true;

  # Включаем поддержку Flatpak.
  services.flatpak.enable = true;


}
