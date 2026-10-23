{ username, hostname }:

let
  homeDirectory = "/home/${username}";
in
rec {
  # Runtime paths keep live repository configuration and private user files out of the Nix store.
  user = rec {
    inherit homeDirectory;
    nixConfigDirectory = "${homeDirectory}/nix-config";
    # Host-specific files that live configs (e.g. niri outputs) include at runtime.
    hostDirectory = "${nixConfigDirectory}/hosts/${hostname}";
    niriConfigDirectory = "${nixConfigDirectory}/modules/desktop/niri/config";
    rimeCustomFile = "${nixConfigDirectory}/modules/desktop/input-method/rime-default.custom.yaml";
    mihomoConfigFile = "${homeDirectory}/.config/mihomo/config.yaml";
    # The compositor module provides this executable; greetd starts it.
    waylandSessionFile = "${homeDirectory}/.wayland-session";
    # Same directory as niri's screenshot-path (general.kdl), so originals and annotated copies sit together.
    screenshotDirectory = "${homeDirectory}/Pictures/Screenshots";
  };

  # These Nix paths are evaluated from the repository and copied to the store as needed.
  assets = rec {
    root = ../assets;
    avatar = root + "/avatars/avatar.jpg";
    wallpapers = {
      nixos = root + "/wallpapers/wallpaper_nixos.jpg";
      rog = root + "/wallpapers/wallpaper_rog.jpg";
    };
    stylixScheme = root + "/schemes/base16/catppuccin-mocha.yaml";
  };
}
