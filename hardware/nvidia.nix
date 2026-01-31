{ config, pkgs, ... }:

{
  # Устанавливаем проприетарный драйвер Nvidia.
  # Используем `pkgs.linuxPackages.nvidiaPackages.stable` для стабильной версии.
  # Для самой последней версии можно использовать `pkgs.linuxPackages.nvidiaPackages.latest`.
  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.latest;
  hardware.nvidia.open = false;

  # Настройки для PRIME (управление гибридной графикой Intel + Nvidia).
  hardware.nvidia.prime = {
    # Для рендеринга всех приложений через Nvidia. Установите в false,
    # если хотите запускать только избранные приложения на Nvidia.
    offload = {
      enable = true;
      enableOffloadCmd = true;
    };

    # Настройки для ноутбуков с Intel.
    intelBusId = "PCI:0@0:2:0"; # Уточните ваш BusID через `lspci | grep VGA`
    nvidiaBusId = "PCI:2@0:0:0";
  };

  # Опции для улучшения работы с Wayland.
  # Это включает поддержку DRM (Direct Rendering Manager)
  # что критично для Wayland сессий.
  hardware.nvidia.modesetting.enable = true;
  
  # Добавляем параметр ядра для включения DRM/KMS.
  # Это помогает избежать "черного экрана" при старте Wayland сессии.
  boot.kernelParams = [ "nvidia-drm.modeset=1" ];

  # Дополнительные пакеты, которые могут быть полезны.
  environment.systemPackages = with pkgs; [
    mesa-demos
    vulkan-tools
  ];
}
