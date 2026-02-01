
{ config, pkgs, ... }:

{
  imports =
    [ 
      # генерируется автоматически
      ./hardware-configuration.nix
      
      # модули
      ./system
      ./hardware
      ./apps
      ./users
    ];

}
