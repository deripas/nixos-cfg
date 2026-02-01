{ ... }:

{
  imports =
    [
      ./boot.nix
      ./network.nix
      ./packages.nix
      ./services.nix
      ./pipewire.nix
      ./fonts.nix
      ./kde.nix
    ];
}
