{ config, inputs, ... }:

{
  imports = [
    inputs.noctalia.homeModules.default
  ];

  stylix.targets.noctalia.enable = false;

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
      shell.clipboard_enabled = false;
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
          "tray"
          "notifications"
          "battery"
          "session"
        ];
        scale = 1.25;
      };

      control_center.width = 900;

      idle = {
        pre_action_fade_seconds = 2;

        behavior.screen-off = {
          action = "lock_and_suspend";
          enabled = true;
          timeout = 600;
        };
      };

      theme = {
        mode = "dark";
        source = "builtin";
        builtin = "Catppuccin";
        wallpaper_scheme = "m3-content";
        community_palette = "Oxocarbon";
      };

      wallpaper = {
        enabled = true;
        directory = "${config.xdg.dataHome}/wallpapers";
        default.path = "${config.xdg.dataHome}/wallpapers/wallpaper_nixos.jpg";
      };
    };
  };
}
