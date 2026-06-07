{
  lib,
  namespace,
  inputs,
  pkgs,
  ...
}:
with lib;
with lib.${namespace}; let
in rec {
  opts.background = "dark";
  colorschemes = {
    kanagawa-paper.enable = true;
  };
  plugins.lualine.settings.options.theme.__raw =
    if opts.background == "light"
    then
      # lua
      ''require("lualine.themes.kanagawa-paper-canvas")''
    else
      # lua
      ''require("lualine.themes.kanagawa-paper-ink")'';
}
