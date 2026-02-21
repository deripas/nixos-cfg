{ ... }:

let
  # Определяем имя хоста.
  hostname = builtins.readFile /etc/hostname;
  systemHostname = builtins.replaceStrings ["\n"] [""] hostname;

  # Собираем путь к файлу конфигурации хоста.
  hostPath = ./hosts + "/${systemHostname}";

in
{
  imports =
    [
      hostPath
    ];

  # Устанавливаем имя хоста в системе.
  #networking.hostName = systemHostname;
}

