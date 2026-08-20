{ pkgs, ... }:

{
  programs.yazi = {
    enable = true;
    enableFishIntegration = true;

    # Keep packaged plugins in one list so adding another Nixpkgs plugin stays trivial.
    plugins = {
      inherit (pkgs.yaziPlugins)
        full-border
        ;
    };
  };

  # Mirror Yazi's configuration tree so related files stay together as it grows.
  xdg.configFile."yazi" = {
    recursive = true;
    source = ./config;
  };
}
