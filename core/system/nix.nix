{ config, pkgs, ... }:

{
  nixpkgs.config = {
    allowUnfree = true;
    allowBroken = false;
  };

  nix.settings = {
    auto-optimise-store = true;
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };
}
