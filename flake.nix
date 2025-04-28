{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    hyprpanel.url = "github:Jas-SinghFSU/HyprPanel";
  };

  outputs =
    { self, nixpkgs, ... }@inputs: # nixpkgs-unstable
    let
      system = "x86_64-linux";
      lib = nixpkgs.lib;
      pkgs = nixpkgs.legacyPackages.${system};

    in
    {
      nixosConfigurations.default = lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          inherit system;
        }; # inherit pkgs-unstable;
        modules = [
          ./configuration.nix
          { nixpkgs.overlays = [ inputs.hyprpanel.overlay ]; }

          # inputs.home-manager.nixosModules.default
        ];
      };
    };
}
