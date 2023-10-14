{
  description = "My derivations";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    xwaylandvideobridge = {
      url = "git+https://invent.kde.org/system/xwaylandvideobridge.git";
      flake = false;
    };
    grimblast = {
      url = "github:hyprwm/contrib?dir=grimblast";
      flake = false;
    };
  };
  outputs = { self, nixpkgs, flake-utils, ... }@inputs:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };
      in
      {
        packages = with pkgs; {
          xwaylandvideobridge = libsForQt5.callPackage ./xwaylandvideobridge.nix { inherit inputs; };
          grimblast = callPackage ./grimblast.nix { inherit inputs; };
          alvr = callPackage ./alvr-appimage.nix {};
        };
      });
}