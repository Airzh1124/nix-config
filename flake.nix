{
  description = "Han's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    fcitx5-vinput = {
      url = "github:xifan2333/fcitx5-vinput";
    };

    # Keep AI coding tools on the upstream-tested package set so Codex can
    # track llm-agents.nix updates independently from the main system input.
    llm-agents.url = "github:numtide/llm-agents.nix";

    noctalia = {
      url = "github:noctalia-dev/noctalia/cachix";
      # inputs.nixpkgs.follows = "nixpkgs"; # this line is optional, prevents downloading two versions of nixpkgs but disables cache
    };

    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    vicinae = {
      url = "github:vicinaehq/vicinae";
    };

    zen-browser = {
      # Community flake that is updated promptly after each Zen release; its
      # Home Manager module is built on Home Manager's Firefox module, so it
      # must follow our home-manager to avoid a second copy.
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs = inputs@{ nixpkgs, ... }:
    let
      username = "han";
      hostname = "rog";
      system = "x86_64-linux";
      paths = import ./lib/paths.nix { inherit username hostname; };
    in
    {
      # `nix fmt` formats the whole tree with nixfmt through treefmt; nixpkgs
      # ships this wrapper, so it needs no extra flake input.
      formatter.${system} = nixpkgs.legacyPackages.${system}.nixfmt-tree;

      nixosConfigurations.${hostname} = nixpkgs.lib.nixosSystem {
        inherit system;

        specialArgs = {
          inherit inputs username hostname paths;
        };

        modules = [ ./hosts/rog ];
      };
    };
}
