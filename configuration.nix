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
      ./local-machine.nix
    ];

  # Версия системы.
  system.stateVersion = "25.11";
}
