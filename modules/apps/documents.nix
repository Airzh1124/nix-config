{ pkgs, ... }:

{
  # Use format-specific readers while keeping both applications themed by Stylix.
  hm.programs = {
    zathura = {
      enable = true;
      # Persist reading progress and keep the window title compact and informative.
      options = {
        continuous-hist-save = true;
        window-title-home-tilde = true;
        window-title-page = true;
        statusbar-page-percent = true;
        scroll-page-aware = true;
        # Start in recolor (Ctrl+R) mode to match the dark desktop; Stylix sets
        # the recolor colors. Ctrl+R still toggles back to original colors.
        recolor = true;
        # Keep colored text and charts recognizable by inverting only lightness,
        # and leave embedded images (photos, figures) in their original colors.
        recolor-keephue = true;
        recolor-reverse-video = true;
      };
    };
    foliate.enable = true;

    obsidian = {
      enable = true;
      cli.enable = true;
    };
  };

  # Chrome and ONLYOFFICE also claim PDF and EPUB; Office formats need no entry
  # because ONLYOFFICE is their only handler.
  hm.xdg.mimeApps.defaultApplications = {
    "application/pdf" = [ "org.pwmt.zathura.desktop" ];
    "application/epub+zip" = [ "com.github.johnfactotum.Foliate.desktop" ];
  };

  hm.home.packages = with pkgs; [
    onlyoffice-desktopeditors
    poppler-utils
    # Typst documents use this system-wide CLI rather than per-project devShells,
    # so it is updated together with Zed's tinymist (see modules/dev/zed.nix).
    typst
  ];
}
