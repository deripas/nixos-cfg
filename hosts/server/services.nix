{ config, pkgs, ... }:

{

  # ssh
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  services.logind.settings.Login = {
    HandleLidSwitch = "ignore";
    IdleAction = "ignore";
  };


  systemd.sleep.extraConfig = ''
    AllowSuspend=no
    AllowHibernation=no
  '';

  services.timesyncd.enable = true;

  # for SSD
  services.smartd.enable = true;
  services.fstrim.enable = true;
}
