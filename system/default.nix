{ ... }:

{
  imports =
    [
      ./boot.nix
      ./locale.nix
      ./network.nix
      ./services.nix
      ./nix.nix
      ./desktop
    ];
}
