{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    screen
    immich-go
  ];

}
