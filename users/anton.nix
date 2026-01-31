{ pkgs, ... }:

{
  users.users.anton = {
    isNormalUser = true;
    description = "Anton";
    shell = pkgs.zsh;
    extraGroups = [
      "wheel"         # Дает право выполнять команды от имени root (sudo)
      "networkmanager"  # Дает право управлять сетевыми подключениями
      # "adbusers"      # Если вы будете использовать adb для Android
      # "libvirtd"      # Для управления виртуальными машинами
    ];
    
  };
}
