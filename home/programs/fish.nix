{ lib, ... }:

{
  programs.fish = {
    enable = true;
    interactiveShellInit = lib.mkAfter ''
      set fish_greeting
      fish_config theme choose catppuccin-mocha --color-theme=dark
    '';

    functions.hkuvpn = {
      description = "Connect to HKUVPN through a local SOCKS5 proxy";
      body = ''
        if not set -q HKU_USER
          echo "Set HKU_USER first: set -Ux HKU_USER youruid@connect.hku.hk" >&2
          return 1
        end

        openconnect \
          --protocol=anyconnect \
          --no-dtls \
          --script-tun \
          --script='ocproxy -D 1080' \
          --user="$HKU_USER" \
          vpn2fa.hku.hk
      '';
    };
  };

  programs.direnv = {
    enable = true;
    # Load project flake devShells in Fish; each project's .envrc still needs
    # an explicit `direnv allow` once before its code may affect this shell.
    enableFishIntegration = true;
    nix-direnv.enable = true;
  };
}
