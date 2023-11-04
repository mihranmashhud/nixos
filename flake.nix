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

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nixos-hardware.url = "github:nixos/nixos-hardware/master";

    nix-gaming.url = "github:fufexan/nix-gaming";

    # home-manager for user configuration
    home-manager = {
      url = "github:nix-community/home-manager/master";
      # The `follows` keyword in inputs is used for inheritance.
      # Here, `inputs.nixpkgs` of home-manager is kept consistent with
      # the `inputs.nixpkgs` of the current flake,
      # to avoid problems caused by different versions of nixpkgs.
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";

    nix-colors.url = "github:misterio77/nix-colors";

    my-derivations.url = "path:./derivations";
  };

  outputs = { self, nixpkgs, nixos-hardware, nix-gaming, home-manager, hyprland, nix-colors, my-derivations, ... }@inputs:
    let
      system = "x86_64-linux";
      drvs = my-derivations.packages.${system};
      pkgs = import nixpkgs {
        inherit system;

        overlays = [
          (final: prev: prev // drvs)
          (final: prev: prev // hyprland.packages.${system})
        ];
        config = {
          allowUnfree = true;
        };
      };
      args = {
        inherit pkgs;
        inherit inputs;
        inherit nix-colors;
      };
    in
    {
      nixosConfigurations = {
        "mihranLaptop" = nixpkgs.lib.nixosSystem {
          inherit system;

          specialArgs = args;
          modules = [
            ./hosts/mihranLaptop/configuration.nix

            nixos-hardware.nixosModules.lenovo-thinkpad-t480

            home-manager.nixosModules.home-manager {
              home-manager = {
                extraSpecialArgs = args;
                useGlobalPkgs = true;
                useUserPackages = true;
                users.mihranmashhud = import ./hosts/mihranLaptop/home.nix;
              };
            }
          ];
        };
        "mihranDesktop" = nixpkgs.lib.nixosSystem {
          inherit system;

          specialArgs = args;
          modules = [
            ./hosts/mihranDesktop/configuration.nix

            nixos-hardware.nixosModules.common-cpu-amd
            nixos-hardware.nixosModules.common-cpu-amd-pstate
            nixos-hardware.nixosModules.common-gpu-amd
            nixos-hardware.nixosModules.common-pc-ssd

            nix-gaming.nixosModules.pipewireLowLatency
            nix-gaming.nixosModules.steamCompat

            home-manager.nixosModules.home-manager {
              home-manager = {
                extraSpecialArgs = args;
                useGlobalPkgs = true;
                useUserPackages = true;
                users.mihranmashhud = import ./hosts/mihranDesktop/home.nix;
              };
            }
          ];
        };
      };
    };
}
