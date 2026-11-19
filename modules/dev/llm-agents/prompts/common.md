# Environment

- This machine runs NixOS. Packages and config are declared in `~/nix-config`
  (flake + home-manager), so imperative installs (`apt`, `pip install --user`,
  `npm -g`) fail or are lost on rebuild.
- Many dotfiles are read-only symlinks into `/nix/store`. To change one, edit
  its source in `~/nix-config` and tell me to rebuild.
- My interactive shell is fish. Commands meant for me to paste must be valid
  fish (`set -x VAR val`, `(cmd)` not `$(cmd)`); scripts you run yourself can
  use bash.
- New projects go in `~/projects/<name>` unless I say otherwise.
- To check what a program or module supports, go cheapest first: `--help` or
  `man` filtered with grep, then `rg` in its source and read only the matching
  region, then web docs. Don't read whole files to find one option.

## Development environments

NixOS has no global toolchains or FHS libraries, so project dependencies come
from a flake devShell, not from system packages or imperative installs.

- Reusable environments live in `~/nix-dev/<name>` (see its README). Prefer
  pointing a project at one of them (`.envrc`: `use flake ~/nix-dev/<name>`)
  over creating a new one. A project-specific environment goes in the
  project's own `flake.nix`.
- When creating a flake, write the nixpkgs input as
  `github:NixOS/nixpkgs/nixos-unstable` (the branch the system follows) but
  lock it to the revision the system runs, so packages are reused from the
  store instead of downloaded again:
  `nix flake lock --override-input nixpkgs github:NixOS/nixpkgs/$(nixos-version --revision)`.
  A plain first lock would pick the branch's latest commit instead. The lock
  is then left alone; run `nix flake update` only when I ask.
- When a specific version is required:
  1. use a versioned attribute from the pinned nixpkgs if one exists
     (`python312`, `nodejs_20`, `gcc13`, ...);
  2. otherwise add a second nixpkgs input pinned to a revision that has it,
     and take only that package from it;
  3. keep the main nixpkgs on the system revision either way.
- Language libraries are managed by the language's own tool inside the shell
  (uv for Python, npm/bun for JS); Nix provides the interpreter and native
  dependencies. Prebuilt binaries from wheels/npm run via nix-ld; add missing
  libraries to `NIX_LD_LIBRARY_PATH` in the devShell.
- Your shell does not load direnv. Run commands inside the environment with
  `nix develop <flake> -c <cmd>` (or `direnv exec . <cmd>`).
- In a git repo, flakes only see tracked files: `git add` a new `flake.nix`, or
  reference it as `path:<dir>`.
- `direnv allow` is a trust decision; tell me to run it instead of running it.
- For a tool you need once, use `nix shell nixpkgs#<pkg> -c <cmd>`. The
  registry already points `nixpkgs` at the system revision.

# Ask before acting

These affect things outside the working tree or are hard to undo, so describe
what you intend and wait for my go-ahead:

- System-level changes (packages, services, audio/hardware settings): give me
  the command or nix diff and let me apply it.
- `git push` and anything that rewrites history.
- Deleting files you didn't create in this session.

# Commit messages

When the current directory is inside a git repository and you changed files in
it, end your reply with a suggested Conventional Commit message for those
changes. I make commits myself, so run `git commit` only when I ask.

- Format: `<type>(<scope>): <description>`; scope is the most specific affected
  project/component, or `repo` for cross-cutting changes.
- Types: `feat`, `fix`, `docs`, `refactor`, `test`, `build`, `ci`, `chore`,
  `perf`, `revert`.
- Description: English, imperative, lowercase start, no trailing period.
- Body: always include one, separated by a blank line. Explain what changed
  and why, since the diff shows how but not the reason. English, wrapped at
  72 columns.
- Breaking change: `<type>(<scope>)!:` plus a `BREAKING CHANGE:` footer if needed.
