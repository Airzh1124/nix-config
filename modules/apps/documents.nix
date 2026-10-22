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
  ];
}
