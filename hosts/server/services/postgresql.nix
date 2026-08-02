{ config, pkgs, ... }:

{
  services.postgresql = {
    enable = true;
    port = 5432;

    package = pkgs.postgresql_18;
    dataDir = "/home/services/postgresql";

    extensions = ps: with ps; [
      pgvector
      vectorchord
    ];
  };
}
