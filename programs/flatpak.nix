{ pkgs, ... }:

let
  flatpak = "${pkgs.flatpak}/bin/flatpak";

  systemApps = [
    "com.github.Matoking.protontricks"
    "com.github.wwmm.easyeffects"
    "ru.yandex.Browser"
  ];
in
{
  services.flatpak.enable = true;

  system.activationScripts.flatpak = ''
    ${flatpak} remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

    for app in ${builtins.concatStringsSep " " systemApps}; do
      ${flatpak} install -y --noninteractive flathub "$app"
    done
  '';
}
