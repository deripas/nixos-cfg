{ config, pkgs, ... }:

{
  # Отключаем старый звуковой сервер PulseAudio.
  services.pulseaudio.enable = false;
  
  # RtKit необходим для предоставления прав реального времени звуковым серверам.
  security.rtkit.enable = true;

  # Включаем PipeWire.
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true; # Поддержка 32-битных ALSA-приложений.
    pulse.enable = true;      # Предоставляет совместимость с PulseAudio.

    # если планируете использовать JACK-приложения.
    jack.enable = true;
  };
}
