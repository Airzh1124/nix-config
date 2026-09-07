# Nix Configuration

Personal NixOS and Home Manager configuration for the `rog` host (`x86_64-linux`).
The desktop session currently uses Niri on Wayland.

## Structure

- `flake.nix`: flake inputs and the `nixosConfigurations.rog` output
- `hosts/rog`: host entry point and hardware configuration
- `modules/nixos`: reusable NixOS modules for desktop, hardware, services, and system settings
- `home`: Home Manager configuration, program modules, and application configs
- `users/han.nix`: system user configuration
- `lib/paths.nix`: shared repository, home-directory, and asset paths
- `assets`: wallpapers, avatar, and color scheme files

Home Manager is wired into the NixOS configuration. User programs belong in
`home/programs`, while standalone packages are grouped in `home/packages.nix`.

## Apply the configuration

Run these commands from the repository root:

```sh
sudo nixos-rebuild switch --flake .#rog
```

To activate the configuration without making it the default boot generation:

```sh
sudo nixos-rebuild test --flake .#rog
```
