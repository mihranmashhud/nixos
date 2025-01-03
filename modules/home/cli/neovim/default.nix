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
with lib.${namespace}; let
  cfg = config.${namespace}.cli.neovim;
in {
  options.${namespace}.cli.neovim = {
    enable = mkBoolOpt false "Whether to enable neovim configuration.";
  };
  config = mkIf cfg.enable {
    # Since neovim-config changes so much I have decided to not include it in the nix config.
    programs.neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
      defaultEditor = true;

      extraLuaConfig =
        # lua
        ''
        vim.g.nix = true
        require"general"
        require"plugins"
        '';

      # Packages to make available to Neovim
      extraPackages = with pkgs; [
        tree-sitter
        nodejs
        luajitPackages.luarocks
        ripgrep
        gcc
        unzip
        typescript

        # Formatters
        alejandra
        stylua

        # Language servers
        tailwindcss-language-server
        svelte-language-server
        ccls
        nil
        nixd
        ltex-ls
        lua-language-server
        pyright
        gopls
        go
      ];

      plugins = with pkgs.vimPlugins; [
        nvim-treesitter.withAllGrammars
        lazy-nvim
      ];
    };
  };
}
