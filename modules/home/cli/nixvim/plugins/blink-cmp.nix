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
    plugins.blink-cmp = {
      enable = true;
      settings = {
        signature.enabled = true;
        completion = {
          list.selection.preselect = false;
          documentation = {
            auto_show = true;
            auto_show_delay_ms = 300;
            window.border = "rounded";
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
      };
    };
  };
}
