{
  lib,
  namespace,
  inputs,
  pkgs,
  config,
  ...
}: {
  plugins.toggleterm = {
    enable = true;
    settings = {
      open_mapping = "[[<c-t>]]";
      shade_terminals = false;
      float_opts.border = config.opts.winborder;
    };
  };
}
