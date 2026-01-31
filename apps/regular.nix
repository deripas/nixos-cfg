{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    distrobox
    podman
    podman-desktop
    telegram-desktop
    protonup-qt
    vlc
    obs-studio
    obs-studio-plugins.obs-vkcapture
    obs-studio-plugins.obs-pipewire-audio-capture
  ];
}
