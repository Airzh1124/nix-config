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

        env HKU_USER="$HKU_USER" expect -c '
          set timeout -1
          if {[catch {exec secret-tool lookup service hkuvpn user $env(HKU_USER)} password]} {
            puts stderr "No HKUVPN password found in the keyring."
            puts stderr "Store it with: secret-tool store --label=HKUVPN service hkuvpn user $env(HKU_USER)"
            exit 1
          }

          spawn openconnect \
            --protocol=anyconnect \
            --no-dtls \
            --script-tun \
            --script "ocproxy -D 1080" \
            --user $env(HKU_USER) \
            vpn2fa.hku.hk
          expect {
            -nocase "Password:" {
              send -- "$password\r"
              unset password
            }
            eof {
              set status [wait]
              exit [lindex $status 3]
            }
          }
          expect {
            -nocase "Response:" { interact }
            eof {
              set status [wait]
              exit [lindex $status 3]
            }
          }
          set status [wait]
          exit [lindex $status 3]
        '
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
