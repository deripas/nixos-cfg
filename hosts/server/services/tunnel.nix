{ config, pkgs, lib, ... }:

{
  systemd.tmpfiles.rules = [
    "d /home/srv 0755 root root -"
    "d /home/srv/tailscale 0750 root root -"
  ];

  systemd.services.tailscale = {
    # Указываем systemd выполнить tmpfiles ДО проверки монтирований и ReadWritePaths
    wants = [ "systemd-tmpfiles-setup.service" ];
    after = [ "systemd-tmpfiles-setup.service" ];

    serviceConfig = {
      ProtectHome = lib.mkForce false;
      ReadWritePaths = [ 
        "/home/srv/tailscale"
      ];
    };
  };

  services.tailscale = {
    enable = true;

    authKeyFile = "/home/srv/tailscale/authkey"; 
    permitCertUid = "caddy";
    extraUpFlags = [
      "--login-server=https://controlplane.tailscale.com"
      "--accept-dns=true"
    ];
  };

  networking.firewall = {
    trustedInterfaces = [ "tailscale0" ];
    allowedUDPPorts = [ config.services.tailscale.port ];
  };
}
