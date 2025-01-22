{
  lib,
  pkgs,
  inputs,
  namespace, # The namespace used for your flake, defaulting to "internal" if not set.
  system, # The system architecture for this host (eg. `x86_64-linux`).
  target, # The Snowfall Lib target for this system (eg. `x86_64-iso`).
  format, # A normalized name for the system target (eg. `iso`).
  virtual, # A boolean to determine whether this system is a virtual target using nixos-generators.
  systems, # An attribute map of your defined hosts.
  config,
  ...
}:
with lib;
with lib.${namespace}; {
  config.programs.nixvim = {
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
  };
}
