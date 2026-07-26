{ ... }:

{
  imports =
    [
      ../../core
      ./boot.nix
      ./hardware.nix
      ./services.nix
      ./users.nix
      ./networking.nix
    ];
}
