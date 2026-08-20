{ config, pkgs, lib, ... }:

let
  unstable = import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz") {
      config = config.nixpkgs.config;
  };
  # Создаем обертку над ffmpeg
  ffmpeg-strict = pkgs.writeShellScriptBin "ffmpeg" ''
    exec ${pkgs.ffmpeg}/bin/ffmpeg -strict -1 "$@"
  '';
in
{

  users.users.immich = {
    extraGroups = [ "video" "render" ];
  };

  # 1. Создаем папку для медиафайлов до старта сервиса
  systemd.tmpfiles.rules = [
    "d /home/srv 0755 root root -"
    "d /raid/backups/immich-restic 0755 root root -"
    "d /home/srv/immich 0750 immich immich -"
  ];

  # 2. Разрешаем доступ к /home в systemd для Immich
  systemd.services.immich-server = {
    # Указываем systemd выполнить tmpfiles ДО проверки монтирований и ReadWritePaths
    wants = [ "systemd-tmpfiles-setup.service" ];
    after = [ "systemd-tmpfiles-setup.service" ];

    path = lib.mkBefore [
      ffmpeg-strict
      pkgs.postgresql_18
    ];

    serviceConfig = {
      ProtectHome = lib.mkForce false;
      PrivateDevices = lib.mkForce false;

      ReadWritePaths = [ "/home/srv/immich" ];
      # мягкий потолок памяти.
      # При превышении ядро давит на процесс через reclaim и swap,
      MemoryAccounting = true;
      MemoryHigh = "8G";
      # Жёсткий предохранитель. Убивает процесс, но локально и предсказуемо.
      MemoryMax = "12G";

      DeviceAllow = [ "/dev/dri/renderD128" "/dev/dri/card1" ];
      # При необходимости даем доступ к файлам устройств
      SupplementaryGroups = [ "video" "render" ];
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

  # 4. Разрешаем home для Restic (S3)
  systemd.services.restic-backups-b2-immich = {
    serviceConfig = {
      ProtectHome = lib.mkForce false;
      ReadWritePaths = [ 
        "/home/srv/immich"
        "/home/srv/restic"  
      ];
    };
  };

  # 5. Настройка Restic (S3)
  services.restic.backups.b2-immich = {
    # Инициализировать репозиторий, если он еще не существует
    initialize = true;

    # Автоматический запуск (после дампа Postgres)
    timerConfig = {
      OnCalendar = "*-*-* 02:00:00";
      Persistent = true;
    };

    # Подключение к Backblaze B2 через S3 API
    repository = "s3:s3.eu-central-003.backblazeb2.com/deripas-immich-backup";
    environmentFile = "/home/srv/restic/immich-b2-env";

    # Что бэкапим:
    paths = [
      "/home/srv/immich"
    ];

    # Исключаем временные и легко регенерируемые файлы (превью, закодированные видео)
    exclude = [
      "/home/srv/immich/thumbs"
      "/home/srv/immich/encoded-video"
    ];

    # Автоматическая очистка старых бэкапов
    pruneOpts = [
      "--keep-daily 7"
      "--keep-weekly 4"
      "--keep-monthly 6"
    ];
  };

  # 6. Разрешаем home для Restic (local)
  systemd.services.restic-backups-local-immich = {
    # Указываем systemd выполнить tmpfiles ДО проверки монтирований и ReadWritePaths
    wants = [ "systemd-tmpfiles-setup.service" ];
    after = [ "systemd-tmpfiles-setup.service" "raid.mount" ];

    serviceConfig = {
      ProtectHome = lib.mkForce false;
      ReadWritePaths = [ 
        "/home/srv/immich"
        "/home/srv/restic"
        "/raid/backups/immich-restic"
      ];
    };
  };

  # 7. Настройка Restic (local)
  services.restic.backups.local-immich = {
    # Инициализировать репозиторий, если он еще не существует
    initialize = true;

    # Автоматический запуск (после дампа Postgres)
    timerConfig = {
      OnCalendar = "*-*-* 01:00:00";
      Persistent = true;
    };

    # Путь к локальному репозиторию на HDD
    repository = "/raid/backups/immich-restic";
    environmentFile = "/home/srv/restic/immich-local-env";

    # Что бэкапим:
    paths = [
      "/home/srv/immich"
    ];

    # Исключаем временные и легко регенерируемые файлы (превью, закодированные видео)
    exclude = [
      "/home/srv/immich/thumbs"
      "/home/srv/immich/encoded-video"
    ];

    # Автоматическая очистка старых бэкапов
    pruneOpts = [
      "--keep-daily 7"
      "--keep-weekly 4"
      "--keep-monthly 12"
    ];
  };


  # нужные пакеты
  environment.systemPackages = [
    unstable.immich-go
    pkgs.restic
  ];
}
