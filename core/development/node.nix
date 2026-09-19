{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    yarn
    nodejs
    node-gyp
  ];

}
