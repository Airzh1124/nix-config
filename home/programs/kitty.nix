{ config, ... }:

{
  programs.kitty = {
    enable = true;
    settings = {
      shell = "${config.programs.fish.package}/bin/fish";
      env = "SHELL=${config.programs.fish.package}/bin/fish";
      confirm_os_window_close = 0;

      # Yazi's file icons require a terminal font containing Nerd Font glyphs.
      font_family = "JetBrainsMono Nerd Font";

      # Hide the window decorations (title-bar and window borders)
      hide_window_decorations = "yes";
    };
  };
}
