{
  lib,
  namespace,
  inputs,
  pkgs,
  config,
  ...
}: {
  plugins.which-key = {
    enable = true;
    settings = {
      plugins.spelling = {
        enabled = true;
        suggestions = 20;
      };
    };
  };
}
