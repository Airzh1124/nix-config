{ lib, pkgs, ... }:

# Zed as the fast daily editor; VS Code stays around for Jupyter notebooks.
{
  hm.programs.zed-editor = {
    enable = true;

    # Install language support through Zed's extension system. Python needs no
    # extension; Zed ships basedpyright and Ruff language server support.
    extensions = [
      "kdl"
      "nix"
      "toml"
      "typst"
    ];

    # Zed prefers language servers found on PATH; provide them from Nix rather
    # than letting Zed download generic binaries at runtime.
    extraPackages = with pkgs; [
      basedpyright
      nixd
      ruff
      taplo
      tinymist
    ];

    # Stylix themes Zed (fonts and colors) through userSettings. Home Manager's
    # default mutable settings.json merges these into the file, so Zed can still
    # save other preferences. Project devShells are picked up through direnv.
    userSettings = {
      # Nix owns the package; Zed's self-updater has nothing to update.
      auto_update = false;

      # Match the VS Code setup: basedpyright for types, Ruff for lint and
      # formatting. Format through the Nix-provided ruff binary and apply its
      # import sorting and fixes on save.
      languages.Python = {
        language_servers = [
          "basedpyright"
          "ruff"
        ];
        formatter.external = {
          command = lib.getExe pkgs.ruff;
          arguments = [
            "format"
            "-"
          ];
        };
        code_actions_on_format = {
          "source.organizeImports.ruff" = true;
          "source.fixAll.ruff" = true;
        };
        format_on_save = "on";
      };

      telemetry = {
        diagnostics = false;
        metrics = false;
      };
    };
  };
}
