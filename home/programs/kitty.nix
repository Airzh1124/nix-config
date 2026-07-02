{ ... }:

{
  programs.kitty = {
    enable = true;
    settings = {
      shell = "fish";
      confirm_os_window_close = 0;
    };
  };
}
