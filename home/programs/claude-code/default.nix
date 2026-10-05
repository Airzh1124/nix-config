{
  config,
  inputs,
  paths,
  pkgs,
  ...
}:

{
  programs.claude-code = {
    enable = true;
    package = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.claude-code;
    # Leave `settings` unset: the module would turn settings.json into a read-only store link,
    # breaking runtime writes from /model, /config and permission prompts.
  };

  # settings.json stays mutable and points its statusLine command at this path. Link the
  # script out of the store so edits in the repo take effect without a rebuild.
  home.file.".claude/statusline.sh".source = config.lib.file.mkOutOfStoreSymlink (
    "${paths.user.nixConfigDirectory}/home/programs/claude-code/statusline.sh"
  );
}
