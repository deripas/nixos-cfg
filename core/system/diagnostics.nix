{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    evtest
    libinput
    lnav
    lazyjournal
  ];

}
