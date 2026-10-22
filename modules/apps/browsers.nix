{ inputs, ... }:

{
  hm.imports = [ inputs.zen-browser.homeModules.default ];

  # Stylix's Zen target needs profileNames, which makes Home Manager own
  # profiles.ini and the profile path; keep the existing profile unmanaged.
  hm.stylix.targets.zen-browser.enable = false;

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

  # Chrome also claims these. Not using the flake's setAsDefaultBrowser: it
  # also takes text/plain and application/json, which should stay on editors.
  # The flake installs the beta build as zen-beta.desktop, not zen.desktop.
  hm.xdg.mimeApps.defaultApplications = {
    "text/html" = [ "zen-beta.desktop" ];
    "application/xhtml+xml" = [ "zen-beta.desktop" ];
    "x-scheme-handler/http" = [ "zen-beta.desktop" ];
    "x-scheme-handler/https" = [ "zen-beta.desktop" ];
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
