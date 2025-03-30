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
    # Include LSP related plugins here as well
    diagnostics = {
      severity_sort = true;
      virtual_text = false;
      signs.text.__raw = ''{
        [vim.diagnostic.severity.ERROR] = " ",
        [vim.diagnostic.severity.WARN] = " ",
        [vim.diagnostic.severity.INFO] = " ",
        [vim.diagnostic.severity.HINT] = " ",
      }'';
    };
    plugins.lsp = {
      enable = true;
      inlayHints = true;
      servers = {
        pyright.enable = true;
        ccls.enable = true;
        svelte.enable = true;
        tailwindcss.enable = true;
        ltex.enable = true;
        gopls.enable = true;
        lua_ls.enable = true;
        nixd.enable = true;
      };
      onAttach = 
      # lua
      ''
        set_group_name("<leader>l", "LSP")
      '';
      keymaps = {
        extra = [
          {
            mode = "n";
            key = "<leader>lr";
            action = "<cmd>Lspsaga rename<cr>";
            options = {
              desc = "Rename";
            };
          }
          {
            mode = "n";
            key = "K";
            action = "<cmd>Lspsaga hover_doc<cr>";
            options = {
              desc = "Hover doc";
            };
          }
          {
            mode = "n";
            key = "<leader>le";
            action = "<cmd>Lspsaga show_line_diagnostics<cr>";
            options = {
              desc = "View line diagnostics";
            };
          }
          {
            mode = "n";
            key = "<leader>ld";
            action = "<cmd>Lspsaga show_cursor_diagnostics<cr>";
            options = {
              desc = "View cursor diagnostics";
            };
          }
          {
            mode = "n";
            key = "<leader>la";
            action = "<cmd>Lspsaga code_action<cr>";
            options = {
              desc = "View code actions";
            };
          }
        ];
        lspBuf = {
          gd = "definition";
          gD = "declaration";
          gi = "implementation";
          gr = "references";
          gs = "signature_help";
        };
        diagnostic = {
          "[d" = "goto_prev";
          "]d" = "goto_next";
        };
      };
    };
    plugins.lspsaga = {
      enable = true;
      codeAction = {
        extendGitSigns = config.programs.nixvim.plugins.gitsigns.enable;
        showServerName = true;
      };
      ui = {
        border = "rounded";
        lines = [ "╰" "├" "│" "─" "╭" ];
      };
      symbolInWinbar.enable = false;
      lightbulb.enable = false;
    };
  };
}
