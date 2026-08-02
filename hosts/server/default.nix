{ ... }:

{
  imports =
    [
      ../../core
      ./boot.nix
      ./hardware.nix
      ./users.nix
      ./networking.nix
      ./tools.nix
      ./services
    ];
}
