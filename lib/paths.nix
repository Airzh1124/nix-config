{ username }:

let
  homeDirectory = "/home/${username}";
in
rec {
  # Runtime paths keep live repository configuration and private user files out of the Nix store.
  user = rec {
    inherit homeDirectory;
    nixConfigDirectory = "${homeDirectory}/nix-config";
    niriConfigDirectory = "${nixConfigDirectory}/home/programs/niri/config";
    mihomoConfigFile = "${homeDirectory}/.config/mihomo/config.yaml";
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
