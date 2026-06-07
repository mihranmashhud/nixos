{
  lib,
  namespace,
  inputs,
  pkgs,
  ...
}: {
  plugins.nvim-autopairs = {
    enable = true;
    settings = {
      map_cr = true;
      map_complete = true;
      auto_select = false;
    };
  };
}
