{ pkgs ? import <nixpkgs> {} }: with pkgs; {
  xwaylandvideobridge = libsForQt5.callPackage ./xwaylandvideobridge.nix {};
  grimblast = callPackage ./grimblast.nix {};
}
