{ config, pkgs, ... }:

{
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;

    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;

    initrd.verbose = false;
    consoleLogLevel = 3;
  };

  boot.swraid.enable = true;
  boot.swraid.mdadmConf = ''
    MAILADDR deripas@yandex.ru
  '';

  boot.kernel.sysctl = {
    "vm.swappiness" = 10;
  };

  swapDevices = [{
      device = "/swapfile";
      size = 16 * 1024; # 16384 MB = 16 GB
  }];
}
