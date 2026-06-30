# Nix Configuration

This repository contains the NixOS and Home Manager configuration for `rog`.

The layout follows a flake-oriented structure:

- `hosts/rog`: host entry point and hardware configuration
- `modules/nixos`: reusable NixOS modules
- `users/han`: system user configuration
- `home`: Home Manager configuration

To build or switch later, use the `rog` flake output from this directory.
