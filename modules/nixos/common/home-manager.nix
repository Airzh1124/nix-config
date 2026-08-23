{ inputs, username, hostname, paths, ... }:

{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit inputs username hostname paths;
    };
    users.${username} = import ../../../home;
  };
}
