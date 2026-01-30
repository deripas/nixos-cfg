{ config, pkgs, ... }:

{
  networking.hostName = "korsar";

  # Enable networking
  networking.networkmanager.enable = true;

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ ];
    allowedUDPPorts = [ 5353 ];
  };

  # Avahi (mDNS / IPP discovery)
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

}
