{ paths, pkgs, ... }:

{
  fonts = {
    # Provide broad Unicode coverage system-wide, including CJK and emoji fonts.
    enableDefaultPackages = true;
    packages = with pkgs; [
      # Metric-compatible substitutes keep Calibri/Cambria Office layouts stable.
      carlito
      caladea
    ];
  };

  stylix = {
    enable = true;
    base16Scheme = paths.assets.stylixScheme;
    image = paths.assets.wallpapers.nixos;
    polarity = "dark";

    targets.fish.enable = false;
  };
}
