{ pkgs, ... }:

let
  rimePlum = pkgs.writeShellApplication {
    name = "rime-plum";
    runtimeInputs = with pkgs; [
      bash
      coreutils
      curl
      git
    ];
    text = ''
      set -euo pipefail

      plum_dir="''${PLUM_DIR:-''${XDG_DATA_HOME:-$HOME/.local/share}/plum}"
      rime_dir="''${RIME_DIR:-''${XDG_DATA_HOME:-$HOME/.local/share}/fcitx5/rime}"

      mkdir -p "$rime_dir"

      if [ ! -d "$plum_dir/.git" ]; then
        if [ -e "$plum_dir" ]; then
          echo "Refusing to replace non-git Plum path: $plum_dir" >&2
          exit 1
        fi
        git clone --depth 1 https://github.com/rime/plum.git "$plum_dir"
      else
        git -C "$plum_dir" pull --ff-only
      fi

      cd "$plum_dir"
      rime_dir="$rime_dir" bash rime-install "$@"
    '';
  };

  rimeInstallIce = pkgs.writeShellApplication {
    name = "rime-install-ice";
    runtimeInputs = [ rimePlum ];
    text = ''
      rime-plum iDvel/rime-ice "$@"
    '';
  };
in
{
  home.packages = [
    rimePlum
    rimeInstallIce
  ];
}
