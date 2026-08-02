{ config, pkgs, lib, ... }:

{
  # 1. Создаем папку для медиафайлов до старта сервиса
  systemd.tmpfiles.rules = [
    "d /home/srv 0755 root root -"
    "d /home/srv/immich 0750 immich immich -"
  ];

  # 2. Разрешаем доступ к /home в systemd для Immich
  systemd.services.immich-server.serviceConfig = {
    after = [ "systemd-tmpfiles-setup.service" ];

    ProtectHome = lib.mkForce false;
    ReadWritePaths = [ "/home/srv/immich" ];
  };

  # 3. Конфигурация Immich
  services.immich = {
    enable = true;
    port = 2283;
    host = "0.0.0.0";
    mediaLocation = "/home/srv/immich";
    openFirewall = true;

    # Redis поднимается и конфигурируется автоматически NixOS:
    redis.enable = true;

    # Настройка подключения к нашей внешней БД:
    database = {
      # Говорим NixOS НЕ пытаться управлять кластером БД заново
      enable = false;

      # Имя созданной базы и пользователя из postgresql.nix
      name = "immich";
      user = "immich";

      # Подключение через локальный сокет PostgreSQL (самый быстрый вариант)
      host = "/run/postgresql";
      port = 5432;
    };
  };
}
