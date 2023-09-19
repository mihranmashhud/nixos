{ config, pkgs, ... }: {
  imports = [
    ./bat.nix
    ./git.nix
    ./neovim.nix
    ./browsers.nix
  ];
}
