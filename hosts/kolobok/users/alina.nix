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
}
