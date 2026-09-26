{ ... }:

{
  programs.mpv = {
    enable = true;

    # Let Niri control the window height instead of mpv resizing it to the video's aspect ratio.
    config."keepaspect-window" = false;
  };
}
