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
    wants = [ "systemd-udev-settle.service" ];
    after = [
      "sound.target"
      "alsa-restore.service"
      "systemd-udev-settle.service"
    ];

    serviceConfig.Type = "oneshot";
    script = ''
      amixer=${pkgs.alsa-utils}/bin/amixer
      card=PCH

      for _ in {1..30}; do
        if "$amixer" -c "$card" scontrols >/dev/null 2>&1; then
          break
        fi
        ${pkgs.coreutils}/bin/sleep 1
      done

      "$amixer" -c "$card" scontrols >/dev/null

      set_if_present() {
        local control="$1"
        shift

        if "$amixer" -c "$card" scontrols | ${pkgs.gnugrep}/bin/grep -Fq "Simple mixer control '$control',"; then
          "$amixer" -c "$card" -q sset "$control" "$@"
        fi
      }

      set_if_present "Mic" 0%
      set_if_present "Mic" mute
      set_if_present "Mic Boost" 0%
    '';
  };

  environment.systemPackages = with pkgs; [
    alsa-utils
    pavucontrol
    pulseaudio
  ];
}
