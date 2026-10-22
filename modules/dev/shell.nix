{ lib, ... }:

{
  hm.programs.fish = {
    enable = true;
    interactiveShellInit = lib.mkAfter ''
      set fish_greeting
      fish_config theme choose catppuccin-mocha --color-theme=dark
    '';
  };

  # Both modules hook into Fish by default (`z`/`zi`; Ctrl-T, Ctrl-R, Alt-C).
  # Yazi's `z` and `Z` keys use the same binaries and zoxide database.
  hm.programs.zoxide.enable = true;
  hm.programs.fzf.enable = true;

  hm.programs.direnv = {
    enable = true;
    # Load project flake devShells in Fish; each project's .envrc still needs
    # an explicit `direnv allow` once before its code may affect this shell.
    enableFishIntegration = true;
    nix-direnv.enable = true;
  };
}
