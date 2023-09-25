{ config, pkgs, ... }: {
  imports = [
    ./kitty.nix
    ./bat.nix
    ./git.nix
    ./neovim.nix
    ./browsers.nix
    ./zsh.nix
    ./starship.nix
  ];
}
