{ ... }:

{
  imports =
    [
      ./gpu-intel.nix
      ./gpu-nvidia.nix
      ./network.nix
      ./auto-login.nix
    ];
}
