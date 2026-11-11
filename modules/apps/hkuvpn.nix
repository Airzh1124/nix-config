{ inputs, ... }:

{
  # HKUVPN in userspace (openconnect + ocproxy SOCKS5 on 127.0.0.1:1080, no tun
  # device). Account and password both live in the desktop keyring; set them
  # with `hkuvpn set-password`.
  imports = [ inputs.hkuvpn.nixosModules.default ];

  programs.hkuvpn.enable = true;
}
