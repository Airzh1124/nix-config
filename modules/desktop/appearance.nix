{
  inputs,
  paths,
  pkgs,
  ...
}:

{
  imports = [ inputs.stylix.nixosModules.stylix ];

  stylix = {
    enable = true;
    base16Scheme = paths.assets.stylixScheme;
    image = paths.assets.wallpapers.nixos;
    polarity = "dark";

    # Provide standard symbolic icons for GTK applications such as Foliate.
    icons = {
      enable = true;
      package = pkgs.papirus-icon-theme;
      dark = "Papirus-Dark";
      light = "Papirus";
    };

    # Fish uses its bundled Catppuccin theme instead (see the fish module).
    targets.fish.enable = false;
  };

  hm.home.pointerCursor = {
    enable = true;
    name = "Bibata-Modern-Classic";
    package = pkgs.bibata-cursors;
    size = 32;
    gtk.enable = true;
    x11.enable = true;
  };

  # XWayland apps (e.g. WeChat) read their scale from Xresources.
  hm.xresources.properties = {
    "Xft.dpi" = 144;
  };
}
