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

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:nixos/nixos-hardware/master";

    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";

    nix-gaming.url = "github:fufexan/nix-gaming";

    waybar.url = "github:Alexays/Waybar";

    zen-browser.url = "github:youwen5/zen-browser-flake";
    zenix.url = "github:anders130/zenix";

    # System deployment
    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Themes
    stylix.url = "github:danth/stylix";
    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell?ref=refs/tags/v0.1.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
    };

    nixneovimplugins.url = "github:jooooscha/nixpkgs-vim-extra-plugins";

    agenix.url = "github:ryantm/agenix";
  };

  outputs = {self, ...} @ inputs: let
    lib = inputs.snowfall-lib.mkLib {
      inherit inputs;
      src = ./.;
    };
  in
    lib.mkFlake {
      channels-config = {
        allowUnfree = true;
        permittedInsecurePackages = [
          "libsoup-2.74.3" # TODO: Remove after https://github.com/NixOS/nixpkgs/pull/429473 is merged.
          "beekeeper-studio-5.2.12"
        ];
      };

      overlays = with inputs; [
        waybar.overlays.default
        nixneovimplugins.overlays.default
        zenix.overlays.default
      ];

      homes.modules = with inputs; [
        catppuccin.homeModules.catppuccin
        nixvim.homeManagerModules.nixvim
        zenix.homeModules.default
      ];

      systems.modules.nixos = with inputs; [
        home-manager.nixosModules.home-manager
        stylix.nixosModules.stylix
        catppuccin.nixosModules.catppuccin
        nix-gaming.nixosModules.platformOptimizations
        agenix.nixosModules.default
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

      checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) inputs.deploy-rs.lib;
    };
}
