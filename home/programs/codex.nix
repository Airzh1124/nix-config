{ pkgs, ... }:

{
  programs.codex = {
    enable = true;

    # Keep AI coding tools sourced from llm-agents.nix without overriding
    # same-named packages at the top level of pkgs.
    package = pkgs.llm-agents.codex;
  };
}
