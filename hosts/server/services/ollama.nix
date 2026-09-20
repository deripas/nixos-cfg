{ pkgs, ... }:

{
  #networking.firewall.allowedTCPPorts = [ 3389 ];

  services.ollama = {
    enable = true;
    port = 11434;
    package = pkgs.ollama-cuda;
  };

  services.open-webui = {
    enable = true;
    port = 11000;
  };
}
