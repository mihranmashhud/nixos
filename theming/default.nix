{ config, pkgs, ... }: {
  imports = [
    ./gtk.nix
    ./qt.nix
  ];
}
