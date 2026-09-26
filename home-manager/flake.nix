{
  description = "Home Manager configuration of Honken -> Pratyush";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixgl = {
      url = "github:nix-community/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

     nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ytm-player = {
        url = "github:peternaame-boop/ytm-player";
        inputs.nixpkgs.follows = "nixpkgs";
    };

    caelestia-shell = {
      url = "github:caelestia-dots/shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    namida = {
        url = "git+https://codeberg.org/iWisp360/namida-nix";
        inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs =
    inputs@{ nixpkgs, home-manager, nixgl, nur, ytm-player, caelestia-shell, namida, ... }:
    let
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        #stdenv.hostPlatform.system = "x86_64-linux"
        #pkgs = nixpkgs.legacyPackages.${stdenv.hostPlatform.system};
        overlays = [ 
        nixgl.overlay
        ytm-player.overlays.default
            ];
      };
    in
    {
      homeConfigurations.honken = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [ ./home.nix ];

        extraSpecialArgs = { inherit inputs; };
      };
    };
}
