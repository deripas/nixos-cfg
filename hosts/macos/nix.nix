{ config, pkgs, ... }:

{
  nixpkgs.config = {
    allowUnfree = true;
    allowBroken = false;
  };

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  # auto-optimise-store is known to break the store on macOS, use periodic optimise instead
  nix.optimise.automatic = true;

  nix.gc = {
    automatic = true;
    interval = { Weekday = 0; Hour = 3; Minute = 0; };
    options = "--delete-older-than 14d";
  };
}
