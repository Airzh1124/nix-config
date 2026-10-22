{ ... }:

{
  # Fix pops when starting and stopping playback on the ALC285 codec.
  # https://wiki.archlinux.org/title/Advanced_Linux_Sound_Architecture/Troubleshooting
  boot.extraModprobeConfig = ''
    options snd_hda_intel power_save=0
  '';

  # The internal microphone is a single mic exposed as a stereo pair; present it
  # as mono with a readable name.
  services.pipewire.wireplumber.extraConfig."10-alc285-internal-mic" = {
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
}
