{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    immich-go
    immich-cli
  ];

}
