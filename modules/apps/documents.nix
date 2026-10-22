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

  hm.home.packages = with pkgs; [
    # Office formats open here by default (see default-apps.nix).
    onlyoffice-desktopeditors
    poppler-utils
  ];
}
