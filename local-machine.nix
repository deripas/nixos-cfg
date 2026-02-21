{ ... }:

let
  # Определяем имя хоста.
  systemHostname = "kolobok";

  # Собираем путь к файлу конфигурации хоста.
  hostPath = ./hosts + "/${systemHostname}";

in
{
  imports =
    [
      hostPath
    ];

  # Устанавливаем имя хоста в системе.
  networking.hostName = systemHostname;
}

