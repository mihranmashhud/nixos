{ config, pkgs, nix-colors, ... }: {
  imports = [
    ./gtk.nix
    ./qt.nix
    nix-colors.homeManagerModules.default
  ];
  colorScheme = nix-colors.colorSchemes.tokyo-night-terminal-dark;
  xresources.properties = {
    "Xcursor.size" = 24;
  };
}
