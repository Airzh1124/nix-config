{ config, paths, ... }:

{
  # Mirror the Fcitx configuration tree as a unit so related addon settings
  # stay together and future conf files do not need individual declarations.
  xdg.configFile."fcitx5" = {
    force = true;
    recursive = true;
    source = ./config;
  };

  xdg.dataFile."fcitx5/rime/default.custom.yaml" = {
    force = true;
    # Rime detects changes by mtime. Keep this file outside the Nix store so
    # the GUI's Deploy action can observe edits and rebuild affected schemas.
    source = config.lib.file.mkOutOfStoreSymlink (
      "${paths.user.nixConfigDirectory}/home/programs/rime/default.custom.yaml"
    );
  };
}
