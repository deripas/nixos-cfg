# Ревью конфигурации NixOS - Рекомендации по улучшению

**Дата:** 2026-02-04
**Конфигурация:** Lenovo с Nvidia Optimus + Wayland + KDE Plasma 6

---

## Общая оценка

Конфигурация в целом хорошо структурирована и логично разделена на модули. Однако есть несколько проблем, особенно связанных с Nvidia Optimus + Wayland + KDE, а также возможности для улучшения организации.

---

## Критические проблемы

### 1. Конфликт X11/Wayland в KDE

**Файл:** `system/kde.nix:17`

**Проблема:**
У вас включен `services.xserver.enable = true` при использовании чистого Wayland, что создает ненужные зависимости. Для современного KDE Plasma 6 с Wayland это не требуется.

**Рекомендация:**
```nix
# Удалить или закомментировать
# services.xserver.enable = true;

# Настройки клавиатуры переместить в более правильное место
console.keyMap = "us";
services.xserver.xkb = {  # Оставить только для XWayland
  layout = "us,ru";
  options = "grp:alt_shift_toggle";
};
```

---

### 2. Nvidia configuration для Wayland

**Файл:** `hardware/nvidia.nix`

**Проблемы:**
- Закомментированный код (строка 5)
- Отсутствует управление питанием
- Нет настроек suspend/hibernate
- Для PRIME offload может не хватать переменных окружения

**Рекомендация:** Добавить в `hardware/nvidia.nix`:
```nix
# Управление питанием
hardware.nvidia.powerManagement = {
  enable = true;
  finegrained = false;  # true только если нужна динамическая смена GPU
};

# Важно для Wayland
environment.sessionVariables = {
  # Для Wayland
  GBM_BACKEND = "nvidia-drm";
  __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  # Для PRIME offload
  __NV_PRIME_RENDER_OFFLOAD = "1";
  __VK_LAYER_NV_optimus = "NVIDIA_only";
};

# Для suspend/resume
boot.kernelParams = [
  "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
];

# VAAPI для hardware acceleration видео
environment.sessionVariables = {
  LIBVA_DRIVER_NAME = "iHD";  # для Intel
  MOZ_ENABLE_WAYLAND = "1";    # для Firefox Wayland
};
```

---

### 3. VirtualBox конфликт

**Файлы:** `users/anton.nix:12`, `apps/programs.nix:45-48`

**Проблема:**
Пользователь в группе `vboxusers`, но VirtualBox закомментирован. Это создает путаницу.

**Рекомендация:**
Удалить `"vboxusers"` из extraGroups или раскомментировать VirtualBox.

---

## Проблемы безопасности

### 4. Autologin включен

**Файл:** `system/kde.nix:11-14`

**Проблема:**
Автологин на домашнем ноутбуке - потенциальная проблема безопасности, особенно если устройство может быть украдено.

**Рекомендация:**
Отключить или зашифровать раздел /home с LUKS.

---

## Организация кода и структура

### 5. Неправильная категоризация модулей

**Проблемы:**
- `system/boot.nix` содержит локализацию, timezone, nix.settings - это не про загрузку
- `apps/` содержит виртуализацию (системный компонент) и shell конфигурацию
- `system/services.nix` слишком минимален

**Рекомендация по рефакторингу структуры:**

```
nixos-cfg/
├── configuration.nix
├── hardware-configuration.nix
├── hardware/
│   ├── default.nix
│   ├── nvidia.nix
│   ├── bluetooth.nix
│   └── power.nix          # ← новый: power-profiles-daemon, thermald
├── system/
│   ├── default.nix
│   ├── boot.nix           # только boot loader
│   ├── locale.nix         # ← новый: timezone, i18n
│   ├── nix.nix            # ← новый: nix.settings, gc
│   ├── network.nix
│   ├── services.nix       # printing, flatpak, avahi
│   └── desktop/           # ← новая директория
│       ├── default.nix
│       ├── kde.nix
│       ├── fonts.nix
│       └── pipewire.nix
├── programs/              # ← переименовать apps/
│   ├── default.nix
│   ├── packages.nix       # основные системные пакеты
│   ├── programs.nix       # firefox, obs, telegram и т.д.
│   ├── gaming.nix
│   └── shell/             # ← новая директория
│       ├── default.nix
│       └── zsh.nix
├── virtualization/        # ← новая директория
│   ├── default.nix
│   ├── podman.nix
│   └── libvirt.nix
└── users/
    ├── default.nix
    └── anton.nix
```

---

### 6. boot.nix перегружен

**Файл:** `system/boot.nix`

**Проблема:**
Файл содержит загрузчик, локализацию, timezone и настройки nix - слишком много ответственности.

**Рекомендация:** Разделить на:
- `system/boot.nix` - только загрузчик и kernel
- `system/locale.nix` - timezone, i18n
- `system/nix.nix` - nix.settings, gc, experimental-features

**Пример `system/boot.nix`:**
```nix
{ config, pkgs, ... }:
{
  system.stateVersion = "25.11";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.initrd.verbose = false;
  boot.kernelParams = [
    "quiet"
    "loglevel=3"
    "systemd.show_status=auto"
    "udev.log_level=3"
  ];

  boot.consoleLogLevel = 3;
}
```

**Пример `system/locale.nix`:**
```nix
{ ... }:
{
  time.timeZone = "Europe/Belgrade";

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

  console.keyMap = "us";
}
```

**Пример `system/nix.nix`:**
```nix
{ ... }:
{
  nix.settings.auto-optimise-store = true;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };
}
```

---

### 7. Дублирование пакетов Zsh

**Файл:** `apps/zsh.nix:41-51`

**Проблема:**
Пакеты уже загружаются через `programs.zsh.shellInit`, не нужно дублировать в `environment.systemPackages`.

**Рекомендация:**
Удалить zsh-плагины из environment.systemPackages, оставить только zsh и meslo-lgs-nf (или переместить meslo-lgs-nf в fonts.nix).

```nix
# Убрать дублирование, оставить только:
environment.systemPackages = with pkgs; [
  zsh
  fzf
];
```

---

## Функциональные улучшения

### 8. Gamemode daemon не настроен

**Файл:** `apps/gaming.nix`

**Проблема:**
Пакет gamemode установлен, но daemon не включен.

**Рекомендация:**
```nix
programs.gamemode = {
  enable = true;
  settings = {
    general = {
      renice = 10;
    };
    gpu = {
      apply_gpu_optimisations = "accept-responsibility";
      gpu_device = 0;
    };
  };
};
```

---

### 9. Steam требует дополнительных настроек

**Файл:** `apps/gaming.nix:5`

**Проблема:**
Для Nvidia PRIME offload и 32-bit libraries нужны дополнительные настройки.

**Рекомендация:**
```nix
programs.steam = {
  enable = true;
  remotePlay.openFirewall = true;
  dedicatedServer.openFirewall = true;
  gamescopeSession.enable = true;
};

# 32-bit OpenGL для Steam (добавить в hardware/gpu-nvidia.nix)
hardware.graphics.enable32Bit = true;
```

---

### 10. Минимальный набор шрифтов

**Файл:** `system/fonts.nix`

**Проблема:**
Может не хватать для emoji, иконок, Nerd Fonts для Powerlevel10k.

**Рекомендация:**
```nix
fonts.packages = with pkgs; [
  noto-fonts
  noto-fonts-cjk-sans
  noto-fonts-emoji        # ← добавить
  liberation_ttf
  font-awesome            # ← добавить
  meslo-lgs-nf           # переместить из zsh.nix
];
```

---

### 11. Виртуализация в неправильном месте

**Файл:** `apps/programs.nix:37-53`

**Проблема:**
Виртуализация - это системный компонент, не приложение.

**Рекомендация:** Создать `virtualization/` директорию:

**`virtualization/default.nix`:**
```nix
{ ... }:
{
  imports = [
    ./podman.nix
    ./libvirt.nix
  ];
}
```

**`virtualization/podman.nix`:**
```nix
{ pkgs, ... }:
{
  virtualisation.containers.enable = true;
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    defaultNetwork.settings.dns_enabled = true;
  };

  environment.systemPackages = with pkgs; [
    distrobox
    podman-desktop
  ];
}
```

**`virtualization/libvirt.nix`:**
```nix
{ ... }:
{
  programs.virt-manager.enable = true;

  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;
}
```

---

## Дополнительные рекомендации

### 12. Добавить power management

**Создать:** `hardware/power.nix`

```nix
{ config, pkgs, ... }:
{
  services.power-profiles-daemon.enable = true;
  services.thermald.enable = true;

  # TLP как альтернатива (несовместим с power-profiles-daemon)
  # services.tlp.enable = true;

  # Для ноутбуков Lenovo - предотвращает throttling
  services.throttled.enable = true;
}
```

Не забыть добавить в `hardware/default.nix`:
```nix
imports = [
  ./nvidia.nix
  ./bluetooth.nix
  ./power.nix  # ← добавить
];
```

---

### 13. KDE настройки можно улучшить

**Файл:** `system/kde.nix`

```nix
# Добавить
services.displayManager.defaultSession = "plasma";  # явно указать

# Для KDE Connect уже есть programs.kdeconnect.enable = true ✓
# Порты для KDE Connect уже открыты в network.nix ✓
```

---

### 14. Bluetooth улучшить настройки

**Файл:** `hardware/bluetooth.nix`

```nix
{ ... }:
{
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
        Experimental = true;  # для лучшей поддержки устройств
      };
    };
  };
}
```

---

## План рефакторинга

Если решите провести полный рефакторинг:

### Шаг 1: Создать новые директории
```bash
mkdir -p system/desktop programs/shell virtualization
```

### Шаг 2: Разделить boot.nix
```bash
# Создать новые файлы
touch system/locale.nix system/nix.nix
```

### Шаг 3: Переместить модули
```bash
# Desktop модули
mv system/kde.nix system/desktop/
mv system/pipewire.nix system/desktop/
mv system/fonts.nix system/desktop/

# Shell модули
mv apps/zsh.nix programs/shell/

# Virtualization (создать новые файлы на основе apps/programs.nix)
# Вручную разделить apps/programs.nix

# Переименовать apps/
mv apps/ programs/
```

### Шаг 4: Обновить default.nix файлы

**`system/default.nix`:**
```nix
{ ... }:
{
  imports = [
    ./boot.nix
    ./locale.nix
    ./nix.nix
    ./network.nix
    ./packages.nix
    ./services.nix
    ./desktop
  ];
}
```

**`system/desktop/default.nix`:**
```nix
{ ... }:
{
  imports = [
    ./kde.nix
    ./pipewire.nix
    ./fonts.nix
  ];
}
```

**`programs/default.nix`:**
```nix
{ ... }:
{
  imports = [
    ./packages.nix
    ./programs.nix
    ./gaming.nix
    ./shell
  ];
}
```

**`programs/shell/default.nix`:**
```nix
{ ... }:
{
  imports = [
    ./zsh.nix
  ];
}
```

**`virtualization/default.nix`:**
```nix
{ ... }:
{
  imports = [
    ./podman.nix
    ./libvirt.nix
  ];
}
```

**`configuration.nix`:**
```nix
{ config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./system
    ./hardware
    ./programs
    ./virtualization  # ← добавить
    ./users
  ];
}
```

### Шаг 5: Применить изменения
```bash
sudo nixos-rebuild switch
```

---

## Итоговые рекомендации по приоритету

### Высокий приоритет
1. ✅ Исправить Nvidia конфигурацию для Wayland (добавить powerManagement, environment variables)
2. ✅ Удалить/закомментировать `services.xserver.enable` в kde.nix
3. ✅ Исправить VirtualBox/vboxusers конфликт
4. ✅ Добавить hardware.graphics.enable32Bit для Steam

### Средний приоритет
5. ⚠️ Рефакторинг структуры (создать system/desktop/, virtualization/, programs/shell/)
6. ⚠️ Разделить boot.nix на логические части
7. ⚠️ Настроить gamemode daemon
8. ⚠️ Добавить больше шрифтов (emoji, font-awesome)

### Низкий приоритет
9. 💡 Улучшить Bluetooth настройки
10. 💡 Добавить services.throttled для Lenovo
11. 💡 Рассмотреть отключение autologin

---

## Полезные команды

```bash
# Проверить конфигурацию без применения
sudo nixos-rebuild dry-build

# Применить конфигурацию
sudo nixos-rebuild switch

# Откатиться к предыдущей генерации
sudo nixos-rebuild switch --rollback

# Проверить Bus ID для Nvidia
lspci | grep VGA

# Проверить что Wayland работает
echo $XDG_SESSION_TYPE

# Проверить драйвер Nvidia
nvidia-smi

# Проверить переменные окружения
env | grep -i nvidia
```

---

**Примечание:** Перед внесением изменений рекомендуется сделать backup конфигурации:
```bash
cp -r /etc/nixos ~/nixos-backup-$(date +%Y%m%d)
```
