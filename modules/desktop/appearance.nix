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

    # Emoji keeps the Stylix default. Noto Serif shares a family with the Noto
    # Serif CJK SC fallback, so mixed Latin/Han serif text matches. The Nerd
    # Font variant of JetBrains Mono also carries the icon glyphs Yazi and shell
    # prompts need; CJK fallbacks are appended in the fonts module.
    fonts = {
      serif = {
        package = pkgs.noto-fonts;
        name = "Noto Serif";
      };
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font";
      };
      sansSerif = {
        package = pkgs.inter;
        name = "Inter";
      };
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
