{ lib, ... }:

{
  hm.programs.fish = {
    enable = true;
    interactiveShellInit = lib.mkAfter ''
      set fish_greeting
      fish_config theme choose catppuccin-mocha --color-theme=dark
    '';
    # Paste with CRs and whitespace after a trailing `\` stripped, so copied line continuations work.
    functions.fish_clipboard_paste_clean = ''
      set -l data (wl-paste -n 2>/dev/null | string replace -r '\r$' "" | string replace -r '\\\\[ \t]+$' '\\\\' | string collect -N)
      string length -q -- "$data"; or return 1
      __fish_paste $data
    '';
    # Replaces the preset Alt-V editor binding; Alt-E still opens $EDITOR.
    binds."alt-v".command = "fish_clipboard_paste_clean";
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
