{ pkgs, ... }:

{
  users.users.han = {
    isNormalUser = true;
    description = "han";
    extraGroups = [ "wheel" "networkmanager" ];
    shell = pkgs.fish;
  };
}
