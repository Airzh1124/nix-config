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
    wireplumber.enable = true;
  };

  # Fix crackling through the mini-jack by disabling analog mic playback
  # monitoring while keeping PipeWire's capture source available.
  systemd.services.mute-mic-playback = {
    description = "Mute ALSA Mic playback to avoid headphone jack crackling";
    wantedBy = [ "multi-user.target" ];
    after = [
      "sound.target"
      "alsa-restore.service"
    ];

    serviceConfig.Type = "oneshot";
    script = ''
      ${pkgs.alsa-utils}/bin/amixer -q sset "Mic" 0% || true
      ${pkgs.alsa-utils}/bin/amixer -q sset "Mic" mute || true
    '';
  };

  environment.systemPackages = with pkgs; [
    alsa-utils
    pavucontrol
    pulseaudio
  ];
}
