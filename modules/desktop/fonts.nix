{ lib, pkgs, ... }:

{
  fonts = {
    # Provide broad Unicode coverage system-wide, including CJK and emoji fonts.
    enableDefaultPackages = true;
    packages = with pkgs; [
      # Metric-compatible substitutes keep Calibri/Cambria Office layouts stable.
      carlito
      caladea

      # Install common UI fonts and all free Font Awesome 7 styles system-wide.
      roboto
      source-sans
      font-awesome_7

      # Yazi renders file icons as Nerd Font glyphs in the terminal.
      nerd-fonts.jetbrains-mono
    ];

    # Stylix puts its chosen fonts first; append Simplified Chinese faces so Han
    # characters fall back to SC glyphs instead of whichever CJK face (often JP)
    # fontconfig would pick on its own.
    fontconfig.defaultFonts = {
      serif = lib.mkAfter [ "Noto Serif CJK SC" ];
      sansSerif = lib.mkAfter [ "Noto Sans CJK SC" ];
      monospace = lib.mkAfter [ "Noto Sans Mono CJK SC" ];
    };
  };
}
