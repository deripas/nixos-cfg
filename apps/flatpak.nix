{ config, pkgs, ... }:

{
  # Включаем поддержку Flatpak.
  services.flatpak.enable = true;

  # Рекомендуется добавить основной репозиторий Flathub.
  # Без него вы не сможете искать и устанавливать приложения.
#   services.flatpak.remotes = [
#     {
#       name = "flathub";
#       location = "https://dl.flathub.org/repo/flathub.flatpakrepo";
#     }
#   ];
}
