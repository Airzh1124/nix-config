{ ... }:

{
  users.users.han = {
    isNormalUser = true;
    description = "han";
    extraGroups = [ "wheel" "networkmanager" "video" ];
  };
}
