{ pkgs, ... }:

{
  programs.steam = {
    enable = true;

    # Keep Valve Proton as the default and expose Proton-GE for games that need
    # its additional compatibility patches.
    extraCompatPackages = [ pkgs.proton-ge-bin ];

    # Translate Steam Input's X11 events for controllers under Niri/Wayland.
    extest.enable = true;
  };

  # Games opt in with the Steam launch option `gamemoderun %command%`.
  programs.gamemode.enable = true;

  # Keep the overlay opt-in so normal desktop applications remain unaffected;
  # use `mangohud gamemoderun %command%` in a game's Steam launch options.
  hm.programs.mangohud.enable = true;
}
