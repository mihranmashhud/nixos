{
  flake-file = {
    description = "Mihran's Nix flake";
    nixConfig = {
      substituters = [
        "https://cache.nixos.org"
        "https://watersucks.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "watersucks.cachix.org-1:6gadPC5R8iLWQ3EUtfu3GFrVY7X6I4Fwz/ihW25Jbv8="
      ];
    };
    inputs = {
      nixos-hardware.url = "github:nixos/nixos-hardware/master";
      nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    };
  };
}
