{
  inputs,
  lib,
  paths,
  pkgs,
  ...
}:

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
        settings = lib.mkMerge [
          (builtins.fromTOML (
            builtins.replaceStrings [ "@xdgDataHome@" ] [ config.xdg.dataHome ] (
              builtins.readFile ./config.toml
            )
          ))

          # Why: with the default `key_source = "secret-service"`, Noctalia
          # looks up its encrypted-storage master key in GNOME Keyring at every
          # start. Under the boot autologin (lock.nix) the keyring is still
          # locked, so the lookup raises an unlock prompt behind swaylock; the
          # PAM unlock in swaylock opens the keyring but Noctalia never closes
          # its own pending prompt, which is left on the desktop.
          # Upstream bug (open as of 2026-10-22):
          # https://github.com/noctalia-dev/noctalia/issues/4704
          #
          # Fix: the documented keyring-free source, where Noctalia reads the
          # key from a file and never touches the Secret Service:
          # https://github.com/noctalia-dev/noctalia/blob/main/docs/user/configuration/secret-service.mdx#avoiding-secret-service-entirely
          #
          # The key is a fixed placeholder in the world-readable Nix store, not
          # a secret: it only protects clipboard history and the calendar
          # cache, both disabled here. It must still be 64 lowercase hex
          # characters, or Noctalia flags encrypted storage as broken. Use a
          # real key (or switch back to the keyring) before enabling either
          # feature, and revisit once #4704 is fixed.
          {
            storage = {
              key_source = "file";
              key_file = "${pkgs.writeText "noctalia-placeholder-storage-key" (lib.strings.replicate 64 "0")}";
            };
          }
        ];
      };
    };
}
