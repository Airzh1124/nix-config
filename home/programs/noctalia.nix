{ config, inputs, ... }:

{
  imports = [
    inputs.noctalia.homeModules.default
  ];

  xdg.dataFile = {
    "avatars/avatar.jpg".source = ../../assets/avatars/avatar.jpg;
    "wallpapers/wallpaper_rog.jpg".source = ../../assets/wallpapers/wallpaper_rog.jpg;
    "wallpapers/wallpaper_nixos.jpg".source = ../../assets/wallpapers/wallpaper_nixos.jpg;
  };

  programs.noctalia = {
    enable = true;

    settings = {
      shell.avatar_path = "${config.xdg.dataHome}/avatars/avatar.jpg";

      theme = {
        mode = "dark";
        source = "builtin";
        builtin = "Catppuccin";
      };

      wallpaper = {
        enabled = true;
        directory = "${config.xdg.dataHome}/wallpapers";
        default.path = "${config.xdg.dataHome}/wallpapers/wallpaper_nixos.jpg";
      };
    };
  };
}
