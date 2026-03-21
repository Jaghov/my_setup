{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # # A flake providing necessary module `programs.steam.rocksmithPatch`
    nixos-rocksmith = {
      url = "github:re1n0/nixos-rocksmith";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self, nixpkgs, ... }@inputs: # nixpkgs-unstable
    let
      system = "x86_64-linux";
      lib = nixpkgs.lib;
      pkgs = import nixpkgs {
        inherit system;

        config = {
          allowUnfree = true;
        };
      };

    in
    {
      nixosConfigurations.default = lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          inherit system;
        }; # inherit pkgs-unstable;
        modules = [
          ./configuration.nix
          #rocksmith module
          inputs.nixos-rocksmith.nixosModules.default
          inputs.nix-index-database.nixosModules.default

          # inputs.home-manager.nixosModules.default
        ];
      };
    };
}
