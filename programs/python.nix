{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs.python313Packages; [
    python
    virtualenv
  ];
}
