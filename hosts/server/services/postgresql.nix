{ config, pkgs, lib, ... }:

{
  systemd.tmpfiles.rules = [
    "d /home/srv 0755 root root -"
    "d /home/srv/postgresql 0700 postgres postgres -"
    "d /home/srv/pgadmin 0700 pgadmin pgadmin -"
  ];

  systemd.services.postgresql = {
    # Указываем systemd выполнить tmpfiles ДО проверки монтирований и ReadWritePaths
    wants = [ "systemd-tmpfiles-setup.service" ];
    after = [ "systemd-tmpfiles-setup.service" ];

    serviceConfig = {
      ProtectHome = lib.mkForce false;
      ReadWritePaths = [ "/home/srv/postgresql" ];

      OOMScoreAdjust = -500;
    };
  };

  services.postgresql = {
    enable = true;
    settings = {
      port = 5432;
      listen_addresses = lib.mkForce  "127.0.0.1";
      shared_preload_libraries = [ "vchord" ];

      shared_buffers = "2GB";
      effective_cache_size = "8GB";
      work_mem = "32MB";
      maintenance_work_mem = "512MB";
    };
    
    package = pkgs.postgresql_18;
    dataDir = "/home/srv/postgresql";

    extensions = ps: with ps; [
      pgvector
      vectorchord
    ];

    ensureDatabases = [
      "immich"
    ];

    ensureUsers = [
      {
        name = "immich";
        ensureDBOwnership = true;
      }
    ];

    # Разрешаем пользователю "immich" подключаться к БД "immich" через сокет:
    authentication = pkgs.lib.mkOverride 10 ''
      # type  database  user     address       auth-method
      local   immich    immich                  trust
      local   all       postgres                trust
      host    all       postgres 127.0.0.1/32   trust
      host    all       postgres ::1/128        trust
    '';
  };

  systemd.services.pgadmin = {
    # Указываем systemd выполнить tmpfiles ДО проверки монтирований и ReadWritePaths
    wants = [ "systemd-tmpfiles-setup.service" ];
    after = [ "systemd-tmpfiles-setup.service" ];

    serviceConfig = {
      ProtectHome = lib.mkForce false;
    };
  };

  services.pgadmin = {
    enable = true;
    port = 5050;
    openFirewall = true;
    initialEmail = "deripas@yandex.ru";
    initialPasswordFile = "/home/srv/pgadmin/pwd";
    settings = {
      # Важно для корректной работы pgAdmin под Nginx подпутем /pgadmin/
      SCRIPT_NAME = "/pgadmin";
    };
  };
}
