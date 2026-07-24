{ pkgs, username, paths, ... }:

{
  imports = [
    ./packages.nix
    ./programs
  ];

  home.username = username;
  home.homeDirectory = paths.user.homeDirectory;

  home.pointerCursor = {
    enable = true;
    name = "Bibata-Modern-Classic";
    package = pkgs.bibata-cursors;
    size = 32;
    gtk.enable = true;
    x11.enable = true;
  };

  xdg.mimeApps = {
    enable = true;
    # Keep desktop-wide application associations declarative, including Yazi's PDF opener.
    defaultApplications = {
      # Use Nautilus when graphical applications request a directory opener.
      "inode/directory" = [ "org.gnome.Nautilus.desktop" ];
      # Keep document openers deterministic across Nautilus, Yazi, and xdg-open.
      "application/pdf" = [ "org.pwmt.zathura.desktop" ];
      "application/epub+zip" = [ "com.github.johnfactotum.Foliate.desktop" ];
      # Open common Microsoft Office formats in the matching ONLYOFFICE editor.
      "application/msword" = [ "onlyoffice-desktopeditors.desktop" ];
      "application/vnd.openxmlformats-officedocument.wordprocessingml.document" = [
        "onlyoffice-desktopeditors.desktop"
      ];
      "application/vnd.ms-excel" = [ "onlyoffice-desktopeditors.desktop" ];
      "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" = [
        "onlyoffice-desktopeditors.desktop"
      ];
      "application/vnd.ms-powerpoint" = [ "onlyoffice-desktopeditors.desktop" ];
      "application/vnd.openxmlformats-officedocument.presentationml.presentation" = [
        "onlyoffice-desktopeditors.desktop"
      ];
      "x-scheme-handler/http" = [ "zen.desktop" ];
      "x-scheme-handler/https" = [ "zen.desktop" ];
      "x-scheme-handler/chrome" = [ "zen.desktop" ];
      "text/html" = [ "zen.desktop" ];
      "application/x-extension-htm" = [ "zen.desktop" ];
      "application/x-extension-html" = [ "zen.desktop" ];
      "application/x-extension-shtml" = [ "zen.desktop" ];
      "application/xhtml+xml" = [ "zen.desktop" ];
      "application/x-extension-xhtml" = [ "zen.desktop" ];
      "application/x-extension-xht" = [ "zen.desktop" ];
      "x-scheme-handler/tg" = [ "org.telegram.desktop.desktop" ];
      "x-scheme-handler/tonsite" = [ "org.telegram.desktop.desktop" ];
    };

    associations.added = {
      "x-scheme-handler/http" = [ "zen.desktop" "firefox.desktop" ];
      "x-scheme-handler/https" = [ "zen.desktop" "firefox.desktop" ];
      "x-scheme-handler/chrome" = [ "zen.desktop" "firefox.desktop" ];
      "text/html" = [ "firefox.desktop" "zen.desktop" ];
      "application/x-extension-htm" = [ "firefox.desktop" "zen.desktop" ];
      "application/x-extension-html" = [ "firefox.desktop" "zen.desktop" ];
      "application/x-extension-shtml" = [ "firefox.desktop" "zen.desktop" ];
      "application/xhtml+xml" = [ "firefox.desktop" "zen.desktop" ];
      "application/x-extension-xhtml" = [ "firefox.desktop" "zen.desktop" ];
      "application/x-extension-xht" = [ "firefox.desktop" "zen.desktop" ];
      "x-scheme-handler/tg" = [ "org.telegram.desktop.desktop" ];
      "x-scheme-handler/tonsite" = [ "org.telegram.desktop.desktop" ];
    };
  };

  # xdg.mimeApps manages both locations; their existing contents are declared above.
  xdg.configFile."mimeapps.list".force = true;
  xdg.dataFile."applications/mimeapps.list".force = true;

  xresources.properties = {
    "Xft.dpi" = 144;
  };

  home.stateVersion = "26.05";
}
