{ config, pkgs, ... }:

{
  hardware.graphics.extraPackages = with pkgs; [
    intel-media-driver
    libva
    intel-gpu-tools
  ];

  # VAAPI для hardware acceleration видео
  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD";
    MOZ_ENABLE_WAYLAND = "1";
  };
}
