{ config, ... }:

{
  programs.kitty = {
    enable = true;
    settings = {
      shell = "${config.programs.fish.package}/bin/fish";
      env = "SHELL=${config.programs.fish.package}/bin/fish";
      confirm_os_window_close = 0;
    };
  };
}
