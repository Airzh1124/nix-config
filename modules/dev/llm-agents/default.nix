{
  inputs,
  paths,
  pkgs,
  ...
}:

let
  llmAgents = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system};
in
{
  nix.settings = {
    # Numtide provides pre-built llm-agents.nix packages such as Codex.
    extra-substituters = [ "https://cache.numtide.com?priority=50" ];
    extra-trusted-public-keys = [
      "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
    ];
  };

  hm =
    { config, ... }:
    {
      programs.claude-code = {
        enable = true;
        package = llmAgents.claude-code;
        # Leave `settings` unset: the module would turn settings.json into a read-only store link,
        # breaking runtime writes from /model, /config and permission prompts.
      };

      # settings.json stays mutable and points its statusLine command at this path. Link the
      # script out of the store so edits in the repo take effect without a rebuild.
      home.file.".claude/statusline.sh".source = config.lib.file.mkOutOfStoreSymlink (
        "${paths.user.nixConfigDirectory}/modules/dev/llm-agents/claude-statusline.sh"
      );

      programs.codex = {
        enable = true;
        package = llmAgents.codex;
        # Keep global Codex instructions declarative without taking over mutable config.toml settings.
        context = ./codex-AGENTS.md;
      };

      home.packages = [
        llmAgents.pi
        # Used by the Claude Code status line script.
        pkgs.jq
      ];
    };
}
