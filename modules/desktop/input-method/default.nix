{
  inputs,
  paths,
  pkgs,
  ...
}:

let
  vinput = inputs.fcitx5-vinput.packages.${pkgs.stdenv.hostPlatform.system}.default;
in
{
  nix.settings = {
    # Use the addon's official cache instead of rebuilding sherpa-onnx locally.
    extra-substituters = [ "https://fcitx5-vinput.cachix.org?priority=60" ];
    extra-trusted-public-keys = [
      "fcitx5-vinput.cachix.org-1:XpX3AA6+dDIX4qJhb1QM7sbTwX6/qSlGvW8Z5NK6XdU="
    ];
  };

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-fluent
      (fcitx5-rime.override {
        rimeDataPkgs = [ rime-ice ];
      })
      # Keep voice input inside the Fcitx5 wrapper so the addon is discoverable.
      vinput
    ];

    # Suppress warnings about IM environment variables under Wayland.
    # https://wiki.nixos.org/wiki/Fcitx5
    fcitx5.waylandFrontend = true;
  };

  hm =
    { config, ... }:
    {
      home.packages = [
        # The package ships its own D-Bus-activatable user service; addon
        # discovery comes from the Fcitx5 wrapper above.
        vinput
        # Doubao IME streams Opus frames and loads this library at runtime.
        pkgs.libopus
      ];

      # Mirror the Fcitx configuration tree as a unit so related addon settings
      # stay together and future conf files do not need individual declarations.
      xdg.configFile."fcitx5" = {
        force = true;
        recursive = true;
        source = ./fcitx5;
      };

      xdg.dataFile."fcitx5/rime/default.custom.yaml" = {
        force = true;
        # Rime detects changes by mtime. Keep this file outside the Nix store so
        # the GUI's Deploy action can observe edits and rebuild affected schemas.
        source = config.lib.file.mkOutOfStoreSymlink paths.user.rimeCustomFile;
      };
    };
}
