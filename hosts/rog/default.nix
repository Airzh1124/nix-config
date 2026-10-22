{ lib, ... }:

let
  # This host enables every feature module: each `.nix` file and each module
  # directory (with its own default.nix) directly under modules/<category>/.
  # To disable a feature, remove its file rather than commenting out a line.
  categoryModules =
    category:
    let
      dir = ../../modules + "/${category}";
      isModule = name: type: type == "directory" || lib.hasSuffix ".nix" name;
    in
    lib.mapAttrsToList (name: _: dir + "/${name}") (lib.filterAttrs isModule (builtins.readDir dir));
in
{
  imports = [
    ./hardware-configuration.nix
    ./audio.nix
    ./display.nix
    ./networking.nix
  ]
  ++ lib.concatMap categoryModules [
    "core"
    "desktop"
    "hardware"
    "apps"
    "dev"
    "services"
  ];

  networking.hostName = "rog";

  # PRIME offload in the nvidia-hybrid specialisation (see `lspci -D`).
  specialisation.nvidia-hybrid.configuration.hardware.nvidia.prime = {
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:2:0:0";
  };
}
