# Nix Configuration

Personal NixOS and Home Manager configuration for the `rog` host (`x86_64-linux`).
The desktop session uses Niri on Wayland.

## Structure

Modules are organized by feature: each file holds both the NixOS and the Home
Manager side of one feature, using `hm.*` as an alias for
`home-manager.users.<user>`.

- `flake.nix`: flake inputs, the formatter, and the `nixosConfigurations.rog` output
- `hosts/rog`: imports every module under `modules/`, plus host-specific hardware, audio,
  display (niri outputs), and networking settings
- `modules/core`: Nix, boot, system defaults, the user account, Home Manager wiring
- `modules/hardware`: NVIDIA (with GPU-mode specialisations), ASUS ROG, audio,
  Bluetooth, graphics, and peripherals
- `modules/desktop`: Niri, Noctalia, Vicinae, input method, lock screen, greetd,
  theming, fonts, and default applications
- `modules/apps`: desktop applications and grouped utility packages
- `modules/dev`: shell, terminal, editors, Git, and AI coding agents
- `modules/services`: Mihomo, OpenSSH, Sunshine, Syncthing, and Tailscale
- `lib/paths.nix`: shared repository, home-directory, and asset paths
- `assets`: wallpapers, avatar, and color scheme files

Niri, Rime, and the Claude Code status line are linked out of the store, so
edits to those files in this checkout apply without a rebuild.

## Apply the configuration

`programs.nh` points `NH_FLAKE` at this checkout, so from anywhere:

```sh
nh os switch   # activate and make it the default boot entry
nh os test     # activate without touching the boot entry
nh os boot     # use on next boot only
```

Format with `nix fmt`.
