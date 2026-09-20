{ pkgs, ... }:

{
  services.ollama = {
    enable = true;
    port = 11434;
    host = "0.0.0.0";
    openFirewall = true;
    package = pkgs.ollama-cuda;
  };

  services.open-webui = {
    enable = true;
    port = 11000;
    host = "0.0.0.0";
    openFirewall = true;
  };
}
