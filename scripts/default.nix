{ config, pkgs, ... }: {
  home.file."scripts".source = ./scripts;
  home.sessionPath = [
    "$HOME/scripts"
  ];
  home.packages = with pkgs; [
    ranger
    feh
  ];
}
