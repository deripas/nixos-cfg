{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    mesa-demos
    libva-utils
    vulkan-tools
    vulkan-validation-layers
  ];
}
