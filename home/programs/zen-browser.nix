{ inputs, ... }:

{
  imports = [ inputs.zen-browser.homeModules.default ];

  programs.zen-browser = {
    enable = true;

    # Nautilus cold starts can exceed Firefox's 1-second ShowItems timeout,
    # causing Zen's fallback to open a duplicate directory window.
    # Kept as extraPrefs/lockPref rather than profiles.*.settings so the
    # existing profile and its profiles.ini stay unmanaged.
    extraPrefs = ''
      lockPref("widget.gtk.file-manager-show-items-timeout-ms", 5000);
    '';
  };
}
