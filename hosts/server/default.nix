{ ... }:

{
  imports =
    [
      ../../core
      ./boot.nix
      ./hardware.nix
      ./users.nix
      ./networking.nix
      ./services
    ];
}
