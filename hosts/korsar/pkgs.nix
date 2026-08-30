{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    immich-go
  ];

}
