{ ... }:

{
  programs.git = {
    enable = true;
    settings.user = {
      name = "Han";
      email = "89295788+Airzh1124@users.noreply.github.com";
    };
  };

  # Managed through the module (not home.packages) so its default
  # gitCredentialHelper lets plain `git push` to GitHub reuse gh's login.
  # The module owns ~/.config/gh/config.yml; remove an existing unmanaged copy
  # before switching, or activation will refuse to clobber it.
  programs.gh.enable = true;
}
