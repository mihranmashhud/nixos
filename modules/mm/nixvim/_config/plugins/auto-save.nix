{
  lib,
  namespace,
  inputs,
  pkgs,
  ...
}: {
  plugins.auto-save = {
    enable = true;
    settings.condition =
      # lua
      ''
        function (buf)
          local exclude_filetypes = {
            "markdown",
            "rmarkdown",
            "pandoc",
            "latex",
          }
          local exclude_files = {}
          local utils = require"auto-save.utils.data"
          return vim.fn.getbufvar(buf, "&modifiable") == 1
            and utils.not_in(vim.fn.getbufvar(buf, "&filetype"), exclude_filetypes)
            and utils.not_in(vim.fn.expand("%:t"), exclude_files)
        end'';
  };
}
