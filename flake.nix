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

    nur.url = "github:nix-community/NUR";

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
  };

  outputs = { self, nixpkgs, nur, nixos-hardware, nix-gaming, home-manager, hyprland, nix-colors, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;

        overlays = [
          nur.overlay
        ];
        config = {
          allowUnfree = true;
        };
      };
      nur-no-pkgs = import nur {
        nurpkgs = import nixpkgs { inherit system; };
      };
      args = {
        inherit pkgs;
        inherit inputs;
        inherit nix-colors;
        inherit nur-no-pkgs;
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
            { nixpkgs.overlays = [nur.overlay]; }

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
