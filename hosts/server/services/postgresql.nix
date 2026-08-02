{ config, pkgs, lib, ... }:

{
  systemd.tmpfiles.rules = [
    "d /home/srv 0755 root root -"
    "d /home/srv/postgresql 0700 postgres postgres -"
  ];

  systemd.services.postgresql.serviceConfig = {
    after = [ "systemd-tmpfiles-setup.service" ];

    ProtectHome = lib.mkForce false;
    ReadWritePaths = [ "/home/srv/postgresql" ];
  };

  services.postgresql = {
    enable = true;
    settings.port = 5432;
    
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
      # type  database  user    address       auth-method
      local   immich    immich                trust
      local   all       postgres              trust
    '';
  };

}
