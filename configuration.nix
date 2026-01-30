
{ config, pkgs, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
      ./users.nix
      ./packages.nix
      ./desktop.nix
      ./network.nix
      <home-manager/nixos>
    ];

  system.stateVersion = "25.11"; 

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Set your time zone.
  time.timeZone = "Europe/Belgrade";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

}
