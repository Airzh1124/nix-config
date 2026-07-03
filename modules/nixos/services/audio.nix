{ ... }:

{
  #Fix Pops when starting and stopping playback
  #https://wiki.archlinux.org/title/Advanced_Linux_Sound_Architecture/Troubleshooting
  boot.extraModprobeConfig = ''
    options snd_hda_intel power_save = 0
  '';
  security.rtkit.enable = true;
}