# Repository Instructions

## Language
- Prefer Chinese when talking with the user.

## Nix Workflow
- This repo is a NixOS flake for host `rog`.
- Use `rg`/`rg --files` for search.
- Do not run Nix evaluation, build, rebuild, or switch commands unless the user explicitly requests it.
- Do not update `flake.lock` unless explicitly requested.

## Hardware Checks
- If GPU detection or a GPU-related test fails inside the sandbox, do not conclude that the GPU or driver is unavailable. Request permission to rerun the relevant read-only check outside the sandbox before diagnosing the host.

## Configuration Style
- Before adding or modifying any path-related configuration, you MUST first inspect `lib/paths.nix`.
- When `lib/paths.nix` already provides a suitable definition, you MUST reuse it instead of duplicating a path literal. Add reusable or centrally meaningful paths there; keep a path local only when it is genuinely one-off and module-specific.
- Organize by feature, not by layer: one module per feature under `modules/{core,hardware,desktop,apps,services,dev}` holds both its NixOS settings and its Home Manager settings (via the `hm.*` alias for `home-manager.users.<user>`).
- Within a feature, prefer Home Manager (`hm.programs.*`, `hm.home.packages`) for user programs and shell integrations; use NixOS options only for services, hardware, boot, networking, and login/session-level settings.
- Binary caches, firewall ports, and user groups a feature needs belong in that feature's module. Always give a cache an explicit `?priority=`; caches without one default to priority 0 and take precedence over cache.nixos.org (40).
- Feature modules that need Home Manager's own `config` (e.g. `config.lib.file.mkOutOfStoreSymlink`, `config.xdg.dataHome`) use the function form `hm = { config, ... }: { ... };`. Flake inputs and `paths` come from the NixOS module arguments.
- Use `config.hardware.nvidia.enabled` for CUDA-dependent choices so specialisations without the NVIDIA driver get non-CUDA builds.
- Host-specific values (interface names, PCI bus IDs, monitors, audio node names) belong in `hosts/rog/`, never in shared modules.
- `hosts/rog/default.nix` is the single list of enabled modules.
- Plain utility packages without a related feature go in `modules/apps/packages.nix`, grouped by purpose.
- When managing a package through Home Manager, inspect the module source first and avoid redundant settings whose defaults already match the intended behavior.
- Avoid creating a separate file for a tiny program config when it clearly belongs with an existing related module.
- Format Nix code with nixfmt (`nix fmt`) style.
- When changing configuration, add nearby comments that explain the intent of the change and any non-obvious constraint it depends on.
