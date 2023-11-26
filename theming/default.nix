{
  config,
  pkgs,
  nix-colors,
  ...
}: {
  imports = [
    ./gtk.nix
    ./qt.nix
    nix-colors.homeManagerModules.default
  ];
  colorScheme = nix-colors.colorSchemes.catppuccin-mocha;
  xresources.properties = {
    "Xcursor.size" = 24;
  };
}
