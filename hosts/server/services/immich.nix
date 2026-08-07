{ config, pkgs, lib, ... }:

let
  unstable = import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz") {
      config = config.nixpkgs.config;
  };
in
{
  # 1. Создаем папку для медиафайлов до старта сервиса
  systemd.tmpfiles.rules = [
    "d /home/srv 0755 root root -"
    "d /home/srv/immich 0750 immich immich -"
  ];

  # 2. Разрешаем доступ к /home в systemd для Immich
  systemd.services.immich-server = {
    # Указываем systemd выполнить tmpfiles ДО проверки монтирований и ReadWritePaths
    wants = [ "systemd-tmpfiles-setup.service" ];
    after = [ "systemd-tmpfiles-setup.service" ];

    path = lib.mkBefore [
      pkgs.postgresql_18
    ];

    serviceConfig = {
      ProtectHome = lib.mkForce false;
      ReadWritePaths = [ "/home/srv/immich" ];
    };
  };

  # 3. Конфигурация Immich
  services.immich = {
    enable = true;
    package = unstable.immich;

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

  environment.systemPackages = [
    unstable.immich-go
  ];
}
