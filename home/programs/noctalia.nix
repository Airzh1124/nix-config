{ config, inputs, ... }:

{
  imports = [
    inputs.noctalia.homeModules.default
  ];

  xdg.dataFile = {
    "wallpapers/wallpaper_rog.jpg".source = ../../assets/wallpapers/wallpaper_rog.jpg;
    "wallpapers/wallpaper_nixos.jpg".source = ../../assets/wallpapers/wallpaper_nixos.jpg;
  };

  programs.noctalia = {
    enable = true;

    settings = {
      theme = {
        mode = "dark";
        source = "builtin";
        builtin = "Catppuccin";
      };

      wallpaper = {
        enabled = true;
        default.path = "${config.xdg.dataHome}/wallpapers/wallpaper_nixos.jpg";
      };
    };
  };
}
