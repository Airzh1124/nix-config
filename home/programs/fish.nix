{ lib, ... }:

{
  programs.fish = {
    enable = true;
    interactiveShellInit = lib.mkAfter ''
      set fish_greeting
      set -g fish_color_valid_path 89b4fa --underline
    '';
  };
}
