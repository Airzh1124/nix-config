{ pkgs, ... }:

{
  # Lets NetworkManager-based UIs manage AnyConnect profiles as well.
  networking.networkmanager.plugins = [ pkgs.networkmanager-openconnect ];

  # Keep HKUVPN in userspace (ocproxy SOCKS5, no tun device) and load its
  # password from the desktop keyring via secret-tool.
  hm.home.packages = with pkgs; [
    openconnect
    ocproxy
    expect
    libsecret
  ];

  hm.programs.fish.functions.hkuvpn = {
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
}
