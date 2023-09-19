{
  description = "My NixOS flake";

  nixConfig = {
    experimental-features = [ "nix-command" "flakes" ];

    extra-substituters = [
      # Nix community's cache server
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs  = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # home-manager for user configuration
    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      # The `follows` keyword in inputs is used for inheritance.
      # Here, `inputs.nixpkgs` of home-manager is kept consistent with
      # the `inputs.nixpkgs` of the current flake,
      # to avoid problems caused by different versions of nixpkgs.
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: 
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;

      config = {
        allowUnfree = true;
      };
    };
  in
  {
    nixosConfigurations = {
      "mihranLaptop" = nixpkgs.lib.nixosSystem {
        inherit system;

        specialArgs = inputs;
        modules = [ 
          ./hosts/mihranLaptop/configuration.nix 

          home-manager.nixosModules.home-manager {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.mihranmashhud = import ./home.nix;
            };
          }
        ];
      };
    };
  };
}
