{
  inputs,
  lib,
  username,
  paths,
  ...
}:

{
  imports = [
    inputs.home-manager.nixosModules.home-manager

    # Feature modules configure both layers in one file; `hm.*` forwards each
    # definition to this user's Home Manager config with normal merge semantics.
    (lib.mkAliasOptionModule [ "hm" ] [ "home-manager" "users" username ])
  ];

  # Feature modules reach flake inputs and paths through the NixOS module
  # arguments, so Home Manager needs no extraSpecialArgs.
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
  };

  # Feature modules add their own entries, only for MIME types that more than
  # one installed application claims.
  hm.xdg.mimeApps.enable = true;
  # xdg.mimeApps manages both locations; replace any copy apps wrote there.
  hm.xdg.configFile."mimeapps.list".force = true;
  hm.xdg.dataFile."applications/mimeapps.list".force = true;

  hm.home = {
    inherit username;
    homeDirectory = paths.user.homeDirectory;
    stateVersion = "26.05";
  };
}
