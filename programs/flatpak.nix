{ ... }:

{
  imports = [
    (builtins.fetchTarball {
      url = "https://github.com/gmodena/nix-flatpak/archive/v0.7.0.tar.gz";
      sha256 = "sha256-7ZCulYUD9RmJIDULTRkGLSW1faMpDlPKcbWJLYHoXcs=";
    } + "/modules/nixos.nix")
  ];

  services.flatpak.enable = true;

  services.flatpak.packages = [
    "com.github.Matoking.protontricks"
    "com.github.wwmm.easyeffects"
    "ru.yandex.Browser"
  ];
}
