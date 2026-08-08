{ ... }:

{
  # Keep the overlay opt-in so normal desktop applications remain unaffected;
  # use `mangohud gamemoderun %command%` in a game's Steam launch options.
  programs.mangohud.enable = true;
}
