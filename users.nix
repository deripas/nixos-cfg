{ pkgs, ... }:

{
  programs.zsh.enable = true;

  users.users.anton = {
    isNormalUser = true;
    description = "Anton";
    shell = pkgs.zsh;
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
  };
}
