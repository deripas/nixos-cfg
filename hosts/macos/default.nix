{ ... }:

{
  imports =
    [
      ../../core/development/go.nix
      ./nix.nix
      ./pkgs.nix
      ./fonts.nix
    ];

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;
}
