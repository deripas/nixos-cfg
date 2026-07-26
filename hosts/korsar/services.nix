{ config, pkgs, ... }:

{
  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["nvidia"];

  services.displayManager = {
    autoLogin = {
      enable = true;
      user = "anton";
    };
  };
}
