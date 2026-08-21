{ pkgs, ... }:

{
  programs.yazi = {
    enable = true;
    enableFishIntegration = true;

    # ouch.yazi calls the standalone ouch binary for archive previews/compression.
    extraPackages = [ pkgs.ouch ];

    # Keep packaged plugins in one list so adding another Nixpkgs plugin stays trivial.
    plugins = {
      inherit (pkgs.yaziPlugins)
        full-border
        ouch
        ;
    };
  };

  # Mirror Yazi's configuration tree so related files stay together as it grows.
  xdg.configFile."yazi" = {
    recursive = true;
    source = ./config;
  };
}
