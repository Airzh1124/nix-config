{ ... }:

{
  services.gnome.gnome-keyring.enable = true;
  services.gnome.gcr-ssh-agent.enable = true;

  programs.seahorse.enable = true;

  security.pam.services.greetd.enableGnomeKeyring = true;

  environment.extraInit = ''
    if [ -z "$SSH_AUTH_SOCK" ] && [ -n "$XDG_RUNTIME_DIR" ]; then
      export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/gcr/ssh"
    fi
  '';
}
