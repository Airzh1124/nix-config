{ paths, ... }:

{
  stylix = {
    enable = true;
    base16Scheme = paths.assets.stylixScheme;
    image = paths.assets.wallpapers.nixos;
    polarity = "dark";

    targets.fish.enable = false;
  };
}
