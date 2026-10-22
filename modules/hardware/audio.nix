{ pkgs, ... }:

{
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  hm.home.packages = with pkgs; [
    alsa-utils
    pavucontrol
    # Provides pactl for scripts talking to PipeWire's Pulse server.
    pulseaudio
  ];
}
