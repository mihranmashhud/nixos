{
  lib,
  namespace,
  inputs,
  pkgs,
  config,
  ...
}: {
  # Enables treesitter related plugins as well
  plugins.treesitter = {
    enable = true;
    folding = true;
    settings = {
      highlight.enable = true;
      indent.enable = true;
      playground.enable = true;
    };
  };
  plugins.ts-comments.enable = true;
  plugins.ts-autotag.enable = true;
}
