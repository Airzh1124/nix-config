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
      shell.ui_scale = 1.25;
      shell.screenshot = {
        copy_to_clipboard = true;
        save_to_file = false;
      };

      bar.default = {
        start = [
          "wallpaper"
          "workspaces"
        ];
        end = [
          "notifications"
          "clipboard"
          "battery"
          "session"
        ];
        scale = 1.25;
      };

      control_center.width = 900;

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
