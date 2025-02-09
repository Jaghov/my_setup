{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    hyprpanel.url = "github:Jas-SinghFSU/HyprPanel";
    # hyprland-qtutils.url = "github:hyprwm/hyprland-qtutils";

    # nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # home-manager = {
    #   url = "github:nix-community/home-manager";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };

  outputs = { self, nixpkgs , ... }@inputs:#nixpkgs-unstable 
  let 
    system = "x86_64-linux";
    lib = nixpkgs.lib;
    pkgs = nixpkgs.legacyPackages.${system};
    # Configure `pkgs-unstable` similarly
    # pkgs-unstable = import nixpkgs-unstable {
    #   inherit system;
    #   config = {
    #     allowUnfree = true;
    #   };
    # };
    
    # pkgs-unstable = nixpkgs-unstable.legacyPackages.${system};
  in
  {
    nixosConfigurations.default = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs; inherit system;  }; #inherit pkgs-unstable;
      modules = [
        ./configuration.nix
        {nixpkgs.overlays = [inputs.hyprpanel.overlay ];}

        # inputs.home-manager.nixosModules.default
      ];
    };
  };
}
