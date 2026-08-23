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
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ nixpkgs, ... }:
    let
      username = "han";
      hostname = "rog";
      system = "x86_64-linux";
      paths = import ./lib/paths.nix { inherit username; };
    in
    {
      nixosConfigurations.${hostname} = nixpkgs.lib.nixosSystem {
        inherit system;

        specialArgs = {
          inherit inputs username hostname paths;
        };

        modules = [ ./hosts/rog ];
      };
    };
}
