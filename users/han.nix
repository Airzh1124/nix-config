{ username, ... }:

{
  users.users.${username} = {
    isNormalUser = true;
    description = username;
    # Sunshine uses /dev/uinput for Moonlight keyboard, mouse, and gamepad input.
    extraGroups = [ "wheel" "networkmanager" "video" "uinput" ];
  };
}
