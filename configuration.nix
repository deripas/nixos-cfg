{ ... }:

let
  # Определяем имя хоста.
  systemHostname = "korsar";

  # Собираем путь к файлу конфигурации хоста.
  hostPath = ./hosts + "/${systemHostname}";

in
{
  imports =
    [
      # Генерируется автоматически
      ./hardware-configuration.nix

      # host config
      hostPath

      # Остальные модули
      ./system
      ./virtualization
      ./programs
      ./hardware
      ./users
    ];

  # Версия системы.
  system.stateVersion = "25.11";

  # Устанавливаем имя хоста в системе.
  networking.hostName = systemHostname;
}
