{ pkgs, ... }:

{
  virtualisation = {
    containers = {
      enable = true;
      registries.settings = {
        registry = [
          { location = "docker.io"; }
          { location = "quay.io"; }
        ];
      };
    };
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  environment.systemPackages = with pkgs; [
    podman-compose
  ];
}
