{ inputs, pkgs, ... }:

{
  programs.codex = {
    enable = true;
    package = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.codex;
    # Keep global Codex instructions declarative without taking over mutable config.toml settings.
    context = ./AGENTS.md;
  };
}
