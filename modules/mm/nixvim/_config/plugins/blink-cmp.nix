{
  lib,
  namespace,
  inputs,
  pkgs,
  ...
}: {
  plugins.blink-cmp = {
    enable = true;
    settings = {
      signature.enabled = true;
      completion = {
        list.selection.preselect = false;
        documentation = {
          auto_show = true;
          auto_show_delay_ms = 300;
        };
        ghost_text.enabled = true;
        menu = {
          auto_show = false;
          draw = {
            columns = [
              {
                __unkeyed-1 = "label";
                __unkeyed-2 = "label_description";
                gap = 1;
              }
              {
                __unkeyed-1 = "kind";
                __unkeyed-2 = "kind_icon";
                gap = 1;
              }
            ];
            treesitter = ["lsp"];
          };
        };
      };
      keymap = {
        "<CR>" = ["select_and_accept" "fallback"];
        "<S-Tab>" = ["select_prev" "fallback"];
        "<Tab>" = ["show" "select_next" "fallback"];
        "<Up>" = ["select_prev" "fallback"];
        "<Down>" = ["select_next" "fallback"];
        "<Esc>" = ["hide" "fallback"];
        "<C-j>" = ["snippet_forward" "fallback"];
        "<C-k>" = ["snippet_backward" "fallback"];
        "<C-u>" = ["scroll_documentation_up" "fallback"];
        "<C-d>" = ["scroll_documentation_down" "fallback"];
      };
      cmdline.keymap = {
        "<CR>" = ["select_and_accept" "fallback"];
        "<S-Tab>" = ["select_prev" "fallback"];
        "<Tab>" = ["show" "select_next" "fallback"];
        "<Up>" = ["select_prev" "fallback"];
        "<Down>" = ["select_next" "fallback"];
        "<Esc>" = ["hide" "fallback"];
        "<C-u>" = ["scroll_documentation_up" "fallback"];
        "<C-d>" = ["scroll_documentation_down" "fallback"];
      };
      sources.default = [
        "lsp"
        "path"
        "snippets"
        "buffer"
        "copilot"
      ];
      sources.providers = {
        copilot = {
          async = true;
          module = "blink-copilot";
          name = "copilot";
        };
      };
    };
  };
  plugins.blink-copilot.enable = true;
  plugins.copilot-lua = {
    enable = true;
    settings = {
      suggestion.enabled = false;
      panel.enabled = false;
      filetypes = {
        markdown = true;
        help = true;
      };
      server_opts_overrides = {
        settings = {
          telemetry.telemetryLevel = "off";
        };
      };
    };
  };
}
