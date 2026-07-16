{ paths, ... }:

{
  imports = [
    ./fish.nix
    ./git.nix
    ./google-chrome.nix
    # ./hyprland
    ./kitty.nix
    ./niri
    ./noctalia
    ./obs.nix
    ./obsidian.nix
    ./rime
    ./swayidle.nix
    ./swaylock.nix
    ./syncthing.nix
    ./vicinae.nix
    ./vscode.nix
    ./yazi.nix
    ./zen-browser.nix
  ];

  programs.nh = {
    enable = true;
    # Target this repository's rog configuration so `nh os switch` needs no flake argument.
    osFlake = "${paths.user.nixConfigDirectory}#rog";
  };
}
