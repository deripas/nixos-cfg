{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    lutris
    winetricks
    mangohud
    zenity
    libadwaita
  ];

}
