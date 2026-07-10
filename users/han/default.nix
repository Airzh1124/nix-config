{ ... }:

{
  users.users.han = {
    isNormalUser = true;
    description = "han";
    # Sunshine uses /dev/uinput for Moonlight keyboard, mouse, and gamepad input.
    extraGroups = [ "wheel" "networkmanager" "video" "uinput" ];
  };
}
