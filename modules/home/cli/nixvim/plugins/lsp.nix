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
    extraPackages = with pkgs; [
      ty
    ];
    diagnostic.settings = {
      severity_sort = true;
      signs.text.__raw = ''        {
                [vim.diagnostic.severity.ERROR] = " ",
                [vim.diagnostic.severity.WARN] = " ",
                [vim.diagnostic.severity.INFO] = " ",
                [vim.diagnostic.severity.HINT] = " ",
              }'';
    };
    lsp = {
      inlayHints.enable = true;
      servers = {
        ty.enable = true;
        ccls.enable = true;
        ts_ls.enable = true;
        svelte.enable = true;
        tailwindcss.enable = true;
        cssls.enable = true;
        ltex.enable = true;
        gopls.enable = true;
        lua_ls.enable = true;
        nixd.enable = true;
        qmlls.enable = true;
        qmlls.settings.command = ["qmlls" "-E"];
      };
      onAttach =
        # lua
        ''
          set_group_name("<leader>l", "LSP")
        '';
      keymaps = [
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
          key = "grn";
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
        {
          mode = "n";
          key = "gd";
          lspBufAction = "definition";
          options = {
            desc = "View definition";
          };
        }
        {
          mode = "n";
          key = "gD";
          lspBufAction = "declaration";
          options = {
            desc = "View declaration";
          };
        }
        {
          mode = "n";
          key = "gI";
          lspBufAction = "implementation";
          options = {
            desc = "View implementation";
          };
        }
        {
          mode = "n";
          key = "gR";
          lspBufAction = "references";
          options = {
            desc = "View definition";
          };
        }
      ];
    };
    plugins.lspconfig.enable = true;
    plugins.lspsaga = {
      enable = true;
      codeAction = {
        extendGitSigns = config.programs.nixvim.plugins.gitsigns.enable;
        showServerName = true;
      };
      ui = {
        lines = ["╰" "├" "│" "─" "╭"];
      };
      symbolInWinbar.enable = false;
      lightbulb.enable = false;
    };
  };
}
