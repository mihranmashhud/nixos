{
  description = "Mihran's NixOS flake";

  nixConfig = {
    substituters = [
      "https://cache.nixos.org"
      "https://hyprland.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    snowfall-lib = {
      url = "github:snowfallorg/lib?ref=dev";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    snowfall-flake = {
      url = "github:snowfallorg/flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    snowfall-thaw = {
      url = "github:snowfallorg/thaw";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:nixos/nixos-hardware/master";

    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";

    nix-gaming.url = "github:fufexan/nix-gaming";

    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1&ref=refs/tags/v0.41.1";

    waybar.url = "github:Alexays/Waybar";

    # System deployment
    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Themes
    stylix.url = "github:danth/stylix";
    catppuccin.url = "github:catppuccin/nix";
  };

  outputs = inputs: let
    lib = inputs.snowfall-lib.mkLib {
      inherit inputs;
      src = ./.;
    };
  in
    lib.mkFlake {
      channels-config = {
        allowUnfree = true;
        permittedInsecurePackages = [];
      };

      overlays = with inputs; [
        snowfall-flake.overlays.default
        snowfall-thaw.overlays.default
        waybar.overlays.default
        hyprland.overlays.default
      ];

      homes.modules = with inputs; [
        catppuccin.homeManagerModules.catppuccin
      ];

      systems.modules.nixos = with inputs; [
        home-manager.nixosModules.home-manager
        stylix.nixosModules.stylix
        catppuccin.nixosModules.catppuccin
      ];

      systems.hosts.mihranDesktop.modules = with inputs; [
        nixos-hardware.nixosModules.common-cpu-amd
        nixos-hardware.nixosModules.common-cpu-amd-pstate
        nixos-hardware.nixosModules.common-gpu-amd
        nixos-hardware.nixosModules.common-pc-ssd
        nix-gaming.nixosModules.pipewireLowLatency
      ];

      systems.hosts.mihranLaptop.modules = with inputs; [
        nixos-hardware.nixosModules.lenovo-thinkpad-t480
      ];

      systems.hosts.mihranWSL.modules = with inputs; [
        nixos-wsl.nixosModules.default
      ];

      templates = {
        devshell.description = "Simple flake dev shell.";
      };

      deploy = lib.mkDeploy {
        inherit (inputs) self;
      };
    };
}
