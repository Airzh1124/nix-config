{
  inputs,
  lib,
  username,
  hostname,
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

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit
        inputs
        username
        hostname
        paths
        ;
    };
  };

  # TODO(rewrite): drop once every home/ module has moved into a feature module.
  hm.imports = [ ../../home ];

  hm.home = {
    inherit username;
    homeDirectory = paths.user.homeDirectory;
    stateVersion = "26.05";
  };
}
