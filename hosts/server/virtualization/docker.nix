{ pkgs, config, ... }:

{
  virtualisation.docker = {
    enable = true;

    # Автоматический запуск демона при загрузке системы
    enableOnBoot = true;

    # Запуск от имени root (стандартный режим для сервера)
    rootless = {
      enable = false;
    };

    # Опционально: регулярная автоматическая очистка неиспользуемых образов/контейнеров
    autoPrune = {
      enable = true;
      dates = "weekly";
      flags = [ "--all" "--force" ];
    };
  };

  # Дополнительные полезные CLI-утилиты для работы с контейнерами на сервере
  environment.systemPackages = with pkgs; [
    docker-compose
    ctop
  ];
}
