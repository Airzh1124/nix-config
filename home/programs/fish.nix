{ lib, ... }:

{
  programs.fish = {
    enable = true;
    interactiveShellInit = lib.mkAfter ''
      set fish_greeting
      fish_config theme choose catppuccin-mocha --color-theme=dark
    '';
  };
}
