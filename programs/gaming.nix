{ config, pkgs, ... }:

{
  programs.steam = {
    enable = true;

    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };

  programs.gamemode = {
    enable = true;
  };

  programs.gamescope = {
    enable = true;
  };

  environment.systemPackages = with pkgs; [
    winetricks
    lutris
    mangohud
    zenity
    libadwaita
  ];

}
