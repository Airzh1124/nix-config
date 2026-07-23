{ pkgs, ... }:

{
  programs.btop = {
    enable = true;
    # Keep GPU monitoring available while allowing Stylix to manage btop's theme.
    package = pkgs.btop.override { cudaSupport = true; };
  };
}
