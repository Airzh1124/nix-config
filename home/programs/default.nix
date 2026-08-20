{ paths, ... }:

{
  imports = [
    ./btop.nix
    ./codex
    ./document-readers.nix
    ./fastfetch.nix
    ./fish.nix
    ./gaming.nix
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
    ./wechat.nix
    ./yazi
    ./zen-browser.nix
  ];

  programs.nh = {
    enable = true;
    # Target this repository's rog configuration so `nh os switch` needs no flake argument.
    osFlake = "${paths.user.nixConfigDirectory}#rog";
  };
}
