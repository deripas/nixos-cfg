{ config, pkgs, ... }:

{
  # Версия системы.
  system.stateVersion = "25.11";

  # Загрузчик.
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.timeout = 3;
  boot.loader.efi.canTouchEfiVariables = true;

  # Рекомендуется использовать LTS ядро для стабильности, 
  # но можно вернуть pkgs.linuxPackages_latest для самого свежего.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.initrd.verbose = false;
  boot.kernelParams = [
    "quiet"
    "loglevel=3"
    "systemd.show_status=auto"
    "udev.log_level=3"
  ];

  boot.consoleLogLevel = 3;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  # Разрешаем установку несвободных пакетов.
  nixpkgs.config.allowUnfree = true;

  # Основные системные пакеты.
  environment.systemPackages = with pkgs; [
    git
    mc
    tree
    jq
    wget
    curl
    htop
    btop
    pciutils
    usbutils
    unzip
    neofetch
    nodejs_24
  ];

  # Укажите ваш часовой пояс.
  time.timeZone = "Europe/Belgrade";

  # Настройки локализации.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ru_RU.UTF-8";
    LC_IDENTIFICATION = "ru_RU.UTF-8";
    LC_MEASUREMENT = "ru_RU.UTF-8";
    LC_MONETARY = "ru_RU.UTF-8";
    LC_NAME = "ru_RU.UTF-8";
    LC_NUMERIC = "ru_RU.UTF-8";
    LC_PAPER = "ru_RU.UTF-8";
    LC_TELEPHONE = "ru_RU.UTF-8";
    LC_TIME = "ru_RU.UTF-8";
  };

  services.power-profiles-daemon.enable = true;
  services.thermald.enable = true;

  nix.settings.auto-optimise-store = true;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

}
