{ pkgs, ... }:

{
  users.users.alina = {
    isNormalUser = true;
    description = "Alina";
    shell = pkgs.zsh;
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
  };

  users.users.anton = {
    isNormalUser = true;
    description = "Anton";
    shell = pkgs.zsh;
    extraGroups = [
      "wheel"
      "networkmanager"
      "podman"
      "libvirtd"
    ];
  };
}
