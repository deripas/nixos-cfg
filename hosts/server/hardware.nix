{ config, pkgs, ... }:

{
  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;

  hardware.graphics.extraPackages = with pkgs; [
    intel-media-driver
    intel-gpu-tools
    libva
  ];

  # VAAPI для hardware acceleration видео
  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD";
    MOZ_ENABLE_WAYLAND = "1";
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
        Experimental = true;
      };
    };
  };
}
