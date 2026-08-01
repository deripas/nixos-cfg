{ pkgs, ... }:

{
  users.users.alina = {
    isNormalUser = true;
    description = "Alina";
    shell = pkgs.zsh;
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
  };

  users.users.anton = {
    isNormalUser = true;
    description = "Anton";
    shell = pkgs.zsh;
    extraGroups = [
      "wheel"
      "networkmanager"
      "podman"
      "libvirtd"
    ];

    openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHhvgx4InwRr8sWtI5pkogCh/AJsS4fwBDOhftTYK7Re"
    ];
  };
}
