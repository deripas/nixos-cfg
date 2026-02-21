{ config, pkgs, ... }:

{
  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;

  environment.systemPackages = with pkgs; [
    mesa-demos
    libva-utils
    vulkan-tools
    vulkan-validation-layers
  ];
}
