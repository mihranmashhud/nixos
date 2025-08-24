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
    clipboard = {
      providers.wl-copy.enable = true;
      register = "unnamedplus";
    };
    opts = {
      autoindent = true;
      autoread = true;
      completeopt = ["menu" "menuone" "noselect"];
      conceallevel = 0;
      cursorline = true;
      encoding = "utf-8";
      expandtab = true;
      exrc = true;
      fileencoding = "utf-8";
      foldlevel = 99;
      hlsearch = true;
      inccommand = "split";
      incsearch = true;
      iskeyword.__raw =
        # lua
        "vim.opt.iskeyword + { \"-\" }";
      laststatus = 2;
      linespace = 1;
      modelines = 1;
      mouse = "a";
      number = true;
      pumheight = 10;
      relativenumber = true;
      scrolloff = 8;
      shiftwidth = 2;
      signcolumn = "auto:4";
      softtabstop = 2;
      spellfile = "./en.utf-8.add";
      spelllang = ["en_us"];
      splitbelow = true;
      splitright = true;
      tabstop = 2;
      termguicolors = true;
      timeoutlen = 300;
      undodir.__raw =
        # lua
        "vim.fn.getenv(\"HOME\")..\"/.local/share/nvim/undodir\"";
      undofile = true;
      updatetime = 100;
      virtualedit = "onemore";
      whichwrap = "<,>,h,l,[,]";
      winborder = "rounded";
      wrap = true;
    };

    globals = {
      mapleader = " ";
      maplocalleader = " ";
      have_nerd_font = true;
    };
  };
}
