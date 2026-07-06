# Repository Instructions

## Language
- Prefer Chinese when talking with the user.

## Nix Workflow
- This repo is a NixOS flake for host `rog`.
- Use `rg`/`rg --files` for search.
- Do not run Nix evaluation, build, rebuild, or switch commands unless the user explicitly requests it.
- Do not update `flake.lock` unless explicitly requested.

## Configuration Style
- Prefer Home Manager for user programs and shell integrations.
- Keep system modules for NixOS services, hardware, boot, networking, and login/session-level system settings.
- Put packages with meaningful Home Manager modules under `home/programs`.
- Put plain utility packages without useful Home Manager modules in `home/packages.nix`, grouped by purpose.
- When managing a package through Home Manager, inspect the module source first and avoid redundant settings whose defaults already match the intended behavior.
- Avoid creating a separate file for a tiny program config when it clearly belongs with an existing related module.
