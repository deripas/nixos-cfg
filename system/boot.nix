{ config, pkgs, ... }:

{
  boot = {
    #kernelPackages = pkgs.linuxPackages_latest;
    kernelPackages = pkgs.linuxPackages_6_18;

    # Загрузчик.
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;

    initrd.verbose = false;
    consoleLogLevel = 3;
  };
}
