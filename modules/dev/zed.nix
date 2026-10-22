{ lib, pkgs, ... }:

# Zed as the fast daily editor; VS Code stays around for Jupyter notebooks.
{
  # VS Code, vim and ONLYOFFICE also claim plain text; without an entry the
  # desktop database happened to pick VS Code.
  hm.xdg.mimeApps.defaultApplications."text/plain" = [ "dev.zed.Zed.desktop" ];

  hm.programs.zed-editor = {
    enable = true;

    # Install language support through Zed's extension system. Python needs no
    # extension; Zed ships basedpyright and Ruff language server support.
    extensions = [
      "kdl"
      "material-icon-theme"
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

      # niri draws no title bars, so ask for server-side decorations; Zed then
      # drops its own window controls and rounded corners.
      window_decorations = "server";

      autosave = "on_focus_change";

      # File-centric panels on the left, AI on the right. Zed 1.24 defaults are
      # the mirror image; the agent's thread list moves with its panel.
      project_panel = {
        dock = "left";
        indent_size = 12;
      };
      git_panel = {
        dock = "left";
        default_width = 240;
        status_style = "label_color";
      };
      outline_panel = {
        dock = "left";
        default_width = 240;
        indent_size = 12;
      };
      collaboration_panel.button = false;
      agent = {
        dock = "right";
        threads_sidebar.position = "right";
      };

      # Same file icons as VS Code (PKief's Material Icon Theme). Stylix only
      # sets the color theme, so the icon theme does not conflict with it.
      icon_theme = "Material Icon Theme";

      # Like VS Code, show file icons on tabs, color tab titles by git status,
      # and mark tabs with errors and warnings; all are off by default.
      tabs = {
        file_icons = true;
        git_status = true;
        show_diagnostics = "all";
      };

      # Commands run in Zed's terminal (git commit, etc.) edit in Zed itself.
      terminal.env.EDITOR = "${lib.getExe pkgs.zed-editor} --wait";

      # Format like `nix fmt` (nixfmt-tree runs plain nixfmt, no --strict);
      # nixd cannot pass formatter arguments, hence the external command.
      languages.Nix = {
        language_servers = [
          "nixd"
          "!nil"
        ];
        formatter.external.command = lib.getExe pkgs.nixfmt;
        format_on_save = "on";
      };

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
