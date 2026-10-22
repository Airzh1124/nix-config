{ inputs, paths, ... }:

{
  nix.settings = {
    # Ahead of cache.nixos.org (40): the shell is rebuilt on every upstream push.
    extra-substituters = [ "https://noctalia.cachix.org?priority=20" ];
    extra-trusted-public-keys = [
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
    ];
  };

  # Noctalia reads the laptop battery state through UPower; without this
  # service its existing battery widget hides itself even when BAT0 exists.
  services.upower.enable = true;

  hm =
    { config, ... }:
    {
      imports = [ inputs.noctalia.homeModules.default ];

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
        settings = builtins.fromTOML (
          builtins.replaceStrings [ "@xdgDataHome@" ] [ config.xdg.dataHome ] (
            builtins.readFile ./config.toml
          )
        );
      };
    };
}
