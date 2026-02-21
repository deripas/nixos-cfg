{ ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./system
      ./virtualization
      ./programs
      ./hardware
      ./users
      ./hostname.nix
    ];

  # Версия системы.
  system.stateVersion = "25.11";
}
