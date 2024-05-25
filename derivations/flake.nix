{
  description = "My derivations";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    xwaylandvideobridge = {
      url = "git+https://invent.kde.org/system/xwaylandvideobridge.git";
      flake = false;
    };
    gitbutler = {
      url = "tarball+https://app.gitbutler.com/downloads/release/linux/x86_64/gz";
      flake = false;
    };
  };
  outputs = {
    self,
    nixpkgs,
    flake-utils,
    ...
  } @ inputs:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {
        inherit system;
      };
    in {
      packages = with pkgs; {
        wlxoverlay = callPackage ./wlxoverlay.nix {};
        # xwaylandvideobridge = libsForQt5.callPackage ./xwaylandvideobridge.nix {inherit inputs;};
        vial-udev-rules = callPackage ./vial-udev-rules.nix {};
        gitbutler = callPackage ./gitbutler.nix {inherit inputs;};
        alvr-latest = callPackage ./alvr {};
      };
    });
}
