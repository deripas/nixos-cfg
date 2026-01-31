{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    distrobox
    podman
    podman-desktop
    telegram-desktop
    protonup-qt
  ];
}
