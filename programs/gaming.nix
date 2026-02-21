{ config, pkgs, ... }:

{
  programs.steam = {
    enable = true;

    remotePlay.openFirewall = false;
    dedicatedServer.openFirewall = false;
    localNetworkGameTransfers.openFirewall = true;
  };

  programs.gamemode = {
    enable = true;
  };

  programs.gamescope = {
    enable = true;
  };

  environment.systemPackages = with pkgs; [
    # support both 32- and 64-bit applications
    wineWowPackages.stable

    # wine-staging (version with experimental features)
    #wineWowPackages.staging

    # native wayland support (unstable)
    #wineWowPackages.waylandFull

    winetricks
    lutris
    mangohud
    zenity
    libadwaita
  ];

#  environment.sessionVariables = {
#    LUTRIS_RUNTIME = "0";
#    PROTOCOL_BUFFERS_PYTHON_IMPLEMENTATION = "python";
#  };

}
