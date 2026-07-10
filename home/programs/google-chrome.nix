{ ... }:

{
  programs.google-chrome = {
    enable = true;

    # Chrome's Nix package already carries libva; the system graphics module
    # provides the Intel iHD VA-API driver. This flag opts Chrome into using it
    # for accelerated video decode.
    commandLineArgs = [
      "--enable-features=VaapiVideoDecoder"
    ];
  };
}
