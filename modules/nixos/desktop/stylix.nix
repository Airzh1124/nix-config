{ inputs, paths, pkgs, ... }:

{
  imports = [ inputs.stylix.nixosModules.stylix ];

  fonts = {
    # Provide broad Unicode coverage system-wide, including CJK and emoji fonts.
    enableDefaultPackages = true;
    packages = with pkgs; [
      # Metric-compatible substitutes keep Calibri/Cambria Office layouts stable.
      carlito
      caladea

      # Install common UI fonts and all free Font Awesome 7 styles system-wide.
      roboto
      source-sans
      font-awesome_7

      # Yazi renders file icons as Nerd Font glyphs in the terminal.
      nerd-fonts.jetbrains-mono
    ];
  };

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

    targets.fish.enable = false;
  };
}
