{ pkgs, lib, ... }:

# Supply NixOS-specific runtime integration without making VS Code settings read-only.
# https://code.visualstudio.com/docs/configure/settings-sync#_recommended-configure-the-keyring-to-use-with-vs-code
{
  # Let VS Code and Settings Sync manage ordinary extensions; project devShells
  # provide language runtimes such as Python and Jupyter kernels.
  programs.vscode = {
    enable = true;

    # VS Code cannot detect the keyring under niri, so select it explicitly for
    # Settings Sync credentials. Pass it as a launch flag instead of argv.json,
    # which Home Manager would turn into a read-only file.
    package = pkgs.vscode.override {
      commandLineArgs = "--password-store=gnome-libsecret";
    };

    # Keep the Stylix theme extension, but leave settings.json writable so VS Code
    # and Settings Sync can manage theme selection, fonts, and editor preferences.
    profiles.default.userSettings = lib.mkForce { };
  };
}
