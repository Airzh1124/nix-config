{
  inputs,
  paths,
  pkgs,
  ...
}:

let
  llmAgents = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system};
  # Global instructions shared by every agent. Harness-specific gaps go in files layered on
  # top: pi's default prompt is minimal, so it also gets pi-append.md; Claude Code's own
  # prompt already covers those rules.
  commonPrompt = ./prompts/common.md;
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
        context = commonPrompt;
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
        context = commonPrompt;
      };

      # pi has no home-manager module; it reads both files from its agent directory.
      home.file.".pi/agent/AGENTS.md".source = commonPrompt;
      home.file.".pi/agent/APPEND_SYSTEM.md".source = ./prompts/pi-append.md;

      home.packages = [
        llmAgents.pi
        # Used by the Claude Code status line script.
        pkgs.jq
      ];
    };
}
