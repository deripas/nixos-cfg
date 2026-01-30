{ config, pkgs, ... }:

{
  networking.firewall = {
    enable = true;


    allowedTCPPorts = [ ];
    allowedUDPPorts = [ ];

    # mDNS / Avahi (поиск принтеров, AirPrint)
    allowedUDPPorts = [ 5353 ];
  };

  # Avahi (mDNS / IPP discovery)
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # CUPS (печать)
  services.printing = {
    enable = true;
    drivers = [ pkgs.gutenprint ];
  };
}
