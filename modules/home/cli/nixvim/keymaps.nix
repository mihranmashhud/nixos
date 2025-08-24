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
  undo_breakpoints = map (key: {
    mode = "i";
    inherit key;
    action = "${key}<c-g>u";
  }) ["," "." "!" "?"];
in {
  config.programs.nixvim = {
    extraConfigLuaPre = ''
      _G.set_group_name = function (lhs, name)
        local ok, wk = pcall(require, "which-key")
        if ok then
          wk.add{ {lhs, group = name } }
        end
      end
    '';
    extraConfigLua = ''
      set_group_name("<leader>a", "Actions")
      set_group_name("<leader>c", "Quickfix List")
    '';
    keymaps =
      [
        # Change indentation without losing selection
        {
          mode = "v";
          key = "<";
          action = "<gv";
        }
        {
          mode = "v";
          key = ">";
          action = ">gv";
        }

        # Completion next and previous rebound to ctrl+j/k
        {
          mode = "i";
          key = "<C-j>";
          action = "(<C-n>)";
          options.expr = true;
        }
        {
          mode = "i";
          key = "<C-k>";
          action = "(<C-p>)";
          options.expr = true;
        }
        {
          mode = "n";
          key = "<C-j>";
          action = "<cmd>cnext<cr>";
          options.expr = true;
        }
        {
          mode = "n";
          key = "<C-k>";
          action = "<cmd>cprev<cr>";
          options.expr = true;
        }

        # Swap : and ;
        {
          mode = ["n" "v"];
          key = ";";
          action = ":";
        }
        {
          mode = ["n" "v"];
          key = ":";
          action = ";";
        }

        # Esc alias
        {
          mode = ["i" "t"];
          key = "jk";
          action = "<esc>";
        }
        {
          mode = ["i" "t"];
          key = "kj";
          action = "<esc>";
        }

        # Move lines around
        {
          mode = "v";
          key = "J";
          action = ":m '>+1<CR>gv=gv";
        }
        {
          mode = "v";
          key = "K";
          action = ":m '<-2<CR>gv=gv";
        }

        # Capital Y does what one would expect
        {
          mode = "n";
          key = "Y";
          action = "y$";
        }

        # J does not move the cursor
        {
          mode = "n";
          key = "J";
          action = "mzJ`z";
        }

        # Unbind Space for leader key
        {
          mode = "n";
          key = "<space>";
          action = "";
        }

        # Actions
        {
          mode = "n";
          key = "<leader>=";
          action = "<c-w>=";
          options = {
            silent = true;
            desc = "balance windows";
          };
        }
        {
          mode = "n";
          key = "<leader>h";
          action = "<cmd>noh<cr>";
          options = {
            silent = true;
            desc = "remove search highlight";
          };
        }
        {
          mode = "n";
          key = "<leader>q";
          action = "<cmd>bd<cr>";
          options = {
            silent = true;
            desc = "quit buffer";
          };
        }
        {
          mode = ["n" "v"];
          key = "<leader>/";
          action = "<cmd>normal gcc<cr>";
          options = {
            silent = true;
            desc = "toggle comment";
          };
        }

        # Quickfix list
        {
          mode = ["n" "v"];
          key = "<leader>co";
          action = "<cmd>copen<cr>";
          options = {
            silent = true;
            desc = "open quickfix list";
          };
        }
        {
          mode = ["n" "v"];
          key = "<leader>cq";
          action = "<cmd>cclose<cr>";
          options = {
            silent = true;
            desc = "close quickfix list";
          };
        }
        {
          mode = ["n" "v"];
          key = "<leader>cj";
          action = "<cmd>cnext<cr>";
          options = {
            silent = true;
            desc = "next entry in quickfix list";
          };
        }
        {
          mode = ["n" "v"];
          key = "<leader>ck";
          action = "<cmd>cprevious<cr>";
          options = {
            silent = true;
            desc = "previous entry in quickfix list";
          };
        }

        {
          mode = ["t"];
          key = "<Esc>";
          action = "<C-\\><C-n>";
          options = {
            noremap = true;
          };
        }

        # Disable middle mouse paste
        {
          key = "<MiddleMouse>";
          action = "<nop>";
        }
      ]
      ++ undo_breakpoints;
  };
}
