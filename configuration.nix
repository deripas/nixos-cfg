
{ config, pkgs, ... }:

{
  imports =
    [ 
      # генерируется автоматически
      ./hardware-configuration.nix
      
      # модули
      ./system
      ./hardware
      ./desktop
      ./apps
      ./users
    ];

}
