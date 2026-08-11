{ config, inputs, paths, ... }:

let
  noctaliaSettings = builtins.fromTOML (
    builtins.replaceStrings
      [ "@xdgDataHome@" ]
      [ config.xdg.dataHome ]
      (builtins.readFile ./config.toml)
  );
in
{
  imports = [
    inputs.noctalia.homeModules.default
  ];

  stylix.targets.noctalia.enable = true;

  xdg.dataFile = {
    "avatars/avatar.jpg".source = paths.assets.avatar;
    "wallpapers/wallpaper_rog.jpg".source = paths.assets.wallpapers.rog;
    "wallpapers/wallpaper_nixos.jpg".source = paths.assets.wallpapers.nixos;
  };

  programs.noctalia = {
    enable = true;

    # Parse the TOML into an attrset so Stylix can merge its generated palette,
    # mode, font, opacity, and default wallpaper with the user-facing settings.
    settings = noctaliaSettings;
  };
}
