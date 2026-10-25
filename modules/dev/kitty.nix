{ ... }:

{
  hm =
    { config, ... }:
    {
      programs.kitty = {
        enable = true;
        settings = {
          shell = "${config.programs.fish.package}/bin/fish";
          env = "SHELL=${config.programs.fish.package}/bin/fish";
          confirm_os_window_close = 0;

          # The font comes from stylix.fonts.monospace, whose Nerd Font glyphs
          # Yazi's file icons need.

          # Hide the window decorations (title-bar and window borders)
          hide_window_decorations = "yes";
        };
        keybindings = {
          # oldest, not current: background helpers (e.g. wl-copy) can be the
          # newest foreground process and report a cwd of /.
          "ctrl+shift+enter" = "launch --cwd=oldest";
        };
      };
    };
}
