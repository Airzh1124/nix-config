{ pkgs, ... }:

{
  # Fix pops when starting and stopping playback.
  # https://wiki.archlinux.org/title/Advanced_Linux_Sound_Architecture/Troubleshooting
  boot.extraModprobeConfig = ''
    options snd_hda_intel power_save=0
  '';

  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber = {
      enable = true;
      extraConfig = {
        "10-alc285-internal-mic" = {
          "monitor.alsa.rules" = [
            {
              matches = [
                {
                  "node.name" = "alsa_input.pci-0000_80_1f.3.analog-stereo";
                  "alsa.mixer_name" = "Realtek ALC285";
                }
              ];
              actions = {
                update-props = {
                  "node.description" = "Realtek ALC285 Internal Microphone";
                  "node.nick" = "Internal Microphone";
                  "audio.channels" = 1;
                  "audio.position" = [ "MONO" ];
                };
              };
            }
          ];
        };
      };
    };
  };

  environment.systemPackages = with pkgs; [
    alsa-utils
    pavucontrol
    pulseaudio
  ];
}
