{ config, pkgs, ... }:

{
  programs.firefox.enable = true;

  programs.virt-manager.enable = true;

  programs.obs-studio = {
    enable = true;

    # optional Nvidia hardware acceleration
    package = (
      pkgs.obs-studio.override {
        cudaSupport = true;
      }
    );

    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-backgroundremoval
      obs-pipewire-audio-capture
      obs-vaapi
      obs-gstreamer
      obs-vkcapture
    ];
  };

  environment.systemPackages = with pkgs; [
    ansible
    distrobox
    podman-desktop
    telegram-desktop
    protonup-qt
    vlc
  ];

  virtualisation = {
    containers.enable = true;
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };

#    virtualbox.host = {
#      enable = true;
#      enableExtensionPack = true;
#    };

    libvirtd.enable = true;

    spiceUSBRedirection.enable = true;
  };


}
