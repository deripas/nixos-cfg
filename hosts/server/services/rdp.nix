{ pkgs, ... }:

{
  # Open the default RDP port (3389)
  networking.firewall.allowedTCPPorts = [ 3389 ];
  networking.firewall.allowedUDPPorts = [ 3389 ];
}
