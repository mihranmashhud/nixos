{
  description = "My NixOS flake";

  nixConfig = {
    experimental-features = ["nix-command" "flakes"];
    auto-optimise-store = true;
    substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
      "https://hyprland.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
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

    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    hyprlock.url = "github:hyprwm/hyprlock";

    waybar.url = "github:Alexays/Waybar";

    nix-colors.url = "github:misterio77/nix-colors";

    ags.url = "github:Aylur/ags";

    drvs = {
      url = "path:./derivations";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nur,
    nixos-hardware,
    nix-gaming,
    home-manager,
    hyprland,
    nix-colors,
    drvs,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;

      overlays = [
        (final: prev: drvs.packages.${system})
        (final: prev: {
          obsidian = prev.obsidian.override {
            electron = final.electron_24;
          };
        })
        nur.overlay
        # hyprland.overlays.default
      ];
      config = {
        allowUnfree = true;
        permittedInsecurePackages = [
          "electron-24.8.6"
          "electron-25.9.0"
        ];
      };
    };
    scripts = import ./modules/scripts.nix {inherit pkgs;};
    nur-no-pkgs = import nur {
      nurpkgs = import nixpkgs {inherit system;};
    };
    args = {
      inherit self;
      inherit pkgs;
      inherit inputs;
      inherit scripts;
      inherit nix-colors;
      inherit nur-no-pkgs;
    };
  in {
    templates = {
      devshell = {
        description = "Simple flake dev shell.";
        path = ./templates/devshell;
      };
    };
    nixosConfigurations = {
      "mihranLaptop" = nixpkgs.lib.nixosSystem {
        inherit system;

        specialArgs = args;
        modules = [
          ./hosts/mihranLaptop/configuration.nix

          nixos-hardware.nixosModules.lenovo-thinkpad-t480

          home-manager.nixosModules.home-manager
          {
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
          {nixpkgs.overlays = [nur.overlay];}

          ./hosts/mihranDesktop/configuration.nix

          nixos-hardware.nixosModules.common-cpu-amd
          nixos-hardware.nixosModules.common-cpu-amd-pstate
          nixos-hardware.nixosModules.common-gpu-amd
          nixos-hardware.nixosModules.common-pc-ssd

          nix-gaming.nixosModules.pipewireLowLatency

          home-manager.nixosModules.home-manager
          {
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
