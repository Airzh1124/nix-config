{ inputs, ... }:

{
  hm.imports = [ inputs.zen-browser.homeModules.default ];

  hm.programs.zen-browser = {
    enable = true;

    # Nautilus cold starts can exceed Firefox's 1-second ShowItems timeout,
    # causing Zen's fallback to open a duplicate directory window.
    # Kept as extraPrefs/lockPref rather than profiles.*.settings so the
    # existing profile and its profiles.ini stay unmanaged.
    extraPrefs = ''
      lockPref("widget.gtk.file-manager-show-items-timeout-ms", 5000);
    '';
  };

  hm.programs.google-chrome = {
    enable = true;

    # Chrome's Nix package already carries libva; the intel-graphics module
    # provides the iHD VA-API driver. This flag opts Chrome into using it for
    # accelerated video decode.
    commandLineArgs = [
      "--enable-features=VaapiVideoDecoder"
    ];
  };
}
