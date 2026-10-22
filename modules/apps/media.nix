{ config, pkgs, ... }:

{
  hm.programs.mpv = {
    enable = true;

    # Let Niri control the window height instead of mpv resizing it to the video's aspect ratio.
    config."keepaspect-window" = false;
  };

  hm.programs.obs-studio = {
    enable = true;

    # NVIDIA hardware acceleration; follow whether this configuration (or
    # specialisation) loads the NVIDIA driver.
    package = pkgs.obs-studio.override {
      cudaSupport = config.hardware.nvidia.enabled;
    };

    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-backgroundremoval
      obs-pipewire-audio-capture
      obs-vaapi
      obs-gstreamer
      obs-vkcapture
    ];
  };

  hm.home.packages = with pkgs; [
    # Image editing and conversion
    imagemagick
    pinta

    # Video thumbnails for file managers
    ffmpegthumbnailer
  ];
}
