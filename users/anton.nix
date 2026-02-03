{ pkgs, ... }:

{
  users.users.anton = {
    isNormalUser = true;
    description = "Anton";
    shell = pkgs.zsh;
    extraGroups = [
      "wheel"
      "networkmanager"
      "podman"
      "vboxusers"
      "libvirtd"
    ];
    
  };
}
