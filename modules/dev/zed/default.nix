{ lib, pkgs, ... }:

# Zed as the fast daily editor; VS Code stays around for Jupyter notebooks.
let
  # Zed cannot show tinymist's Preview code lens (VS Code implements it in its
  # client), so a keybinding runs this to open the live preview instead.
  typstOpenPreview = pkgs.writeShellApplication {
    name = "typst-open-preview";
    runtimeInputs = with pkgs; [
      gawk
      iproute2
      libnotify
      procps
      xdg-utils
    ];
    text = builtins.readFile ./typst-open-preview.sh;
  };
in
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

      # Match VS Code's 18px editor text. Stylix derives 16px from its terminal
      # size, which kitty shares, so override Zed alone instead.
      buffer_font_size = lib.mkForce 18;

      # Zed ignores fontconfig fallbacks; use SC glyphs like kitty.
      buffer_font_fallbacks = [ "Noto Sans Mono CJK SC" ];

      # Let niri own the window frame: Zed then drops its window controls and
      # rounded corners. niri only offers server-side decorations while its
      # prefer-no-csd option is on; otherwise Zed falls back to drawing its own.
      window_decorations = "server";

      autosave = "on_focus_change";

      # Wrap long lines at the window edge (Zed defaults to "none"). This is
      # display-only: no newlines are written into the file.
      soft_wrap = "editor_width";

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

      # Color tab titles by git status and mark tabs with errors and warnings;
      # both are off by default.
      tabs = {
        git_status = true;
        show_diagnostics = "all";
      };

      title_bar.show_user_picture = false;

      # Commands run in Zed's terminal (git commit, etc.) edit in Zed itself.
      terminal.env.EDITOR = "${lib.getExe pkgs.zed-editor} --wait";
      terminal.font_fallbacks = [ "Noto Sans Mono CJK SC" ];

      # Format like `nix fmt` (nixfmt-tree runs plain nixfmt, no --strict);
      # nixd cannot pass formatter arguments, hence the external command. "-"
      # reads stdin; nixfmt warns that a bare invocation is deprecated.
      languages.Nix = {
        language_servers = [
          "nixd"
          "!nil"
        ];
        formatter.external = {
          command = lib.getExe pkgs.nixfmt;
          arguments = [ "-" ];
        };
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

      # Zed has no webview, so preview Typst in a browser: tinymist serves a
      # live preview of the focused document that follows the unsaved buffer.
      # It is read at server start, hence initialization_options rather than
      # settings. tinymist re-focuses on hover/folding/semantic-token requests,
      # not on tab switches, so hover over the new file to move the preview.
      # The default fixed port 23635 makes every tinymist after the first panic
      # with AddrInUse, killing LSP in the other windows; each instance takes a
      # random port instead, which the task below looks up.
      lsp.tinymist.initialization_options.preview.background = {
        enabled = true;
        args = [
          "--data-plane-host=127.0.0.1:0"
          "--invert-colors=auto"
        ];
      };

      telemetry = {
        diagnostics = false;
        metrics = false;
      };
    };

    # Pass the file through env rather than args: task args go through the
    # shell, and paths such as "MSc(AI)" would need fish-specific quoting.
    userTasks = [
      {
        label = "Typst: open preview";
        command = lib.getExe typstOpenPreview;
        env.TYPST_FILE = "$ZED_FILE";
        reveal = "never";
        hide = "on_success";
      }
    ];

    # Same key Zed uses for Markdown and SVG previews.
    userKeymaps = [
      {
        context = "Editor && extension == typ";
        bindings."ctrl-shift-v" = [
          "task::Spawn"
          { task_name = "Typst: open preview"; }
        ];
      }
    ];
  };
}
