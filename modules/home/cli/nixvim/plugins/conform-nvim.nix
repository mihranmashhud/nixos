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
    extraPackages = with pkgs; [
      prettierd
      isort
      black
      alejandra
      stylua
      rustywind
    ];
    plugins.conform-nvim = {
      enable = true;
      settings = {
        formatters = {
          svelte_fmt = {
            command = "npx";
            args = ["prettier" "--plugin" "prettier-plugin-svelte" "$FILENAME"];
          };
        };
        formatters_by_ft = {
          lua = ["stylua"];
          python = ["isort" "black"];
          javascript = ["prettierd"];
          typescript = ["prettierd"];
          javascriptreact = ["prettierd"];
          typescriptreact = ["prettierd"];
          svelte = ["rustywind" "svelte_fmt"];
          nix = ["alejandra"];
        };
        format_on_save =
          # lua
          ''
            function(bufnr)
              -- Disable with a global or buffer-local variable
              if not vim.g.formatonsave or not vim.b[bufnr].formatonsave then
                return
              end
              return { timeout_ms = 500, lsp_fallback = true }
            end
          '';
      };
    };
    globals.formatonsave = false;
    extraConfigLuaPre = ''
      function mutate_formatonsave(g, b)
        return function(args)
          if args.bang then
            vim.g.formatonsave = g
          else
            vim.b.formatonsave = b
          end
        end
      end
    '';
    keymaps = [
      {
        mode = ["n" "v"];
        key = "<leader>lf";
        action = "<cmd>Format<cr>";
      }
    ];
    userCommands = {
      Format = {
        command.__raw = ''
          function(args)
            local range = nil
            if args.count ~= -1 then
              local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
              range = {
                ["start"] = { args.line1, 0 },
                ["end"] = { args.line2, end_line:len() },
              }
            end
            require("conform").format({ async = true, lsp_fallback = true, range = range })
          end
        '';
        range = true;
      };
      FormatOnSaveToggle = {
        command.__raw = "mutate_formatonsave(not vim.g.formatonsave, not vim.b.formatonsave)";
        desc = "Toggle format on save";
        bang = true;
      };
      FormatOnSaveEnable = {
        command.__raw = "mutate_formatonsave(true, true)";
        desc = "Enable format on save";
        bang = true;
      };
      FormatOnSaveDisable = {
        command.__raw = "mutate_formatonsave(false, false)";
        desc = "Disable format on save";
        bang = true;
      };
    };
  };
}
