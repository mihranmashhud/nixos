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
  cfg = config.${namespace}.apps.rofi;
in {
  options.${namespace}.apps.rofi = {
    enable = mkBoolOpt false "Whether to enable rofi configuration.";
  };
  config = mkIf cfg.enable {
    programs.rofi = {
      enable = true;
      package = pkgs.rofi-wayland;
      font = "monospace 12";
      extraConfig = {
        modi = "drun,filebrowser";
        show-icons = true;
        icon-theme = "Papirus";
        drun-display-format = "{name}";
        disable-history = false;
        sort = true;
        sorting-method = "fzf";
        case-sensitive = false;
        sidebar-mode = false;
        matching = "fuzzy";
        m = "-1";
        display-drun = "  ";
        # display-window = "  ";
        display-filebrowser = "  ";
        kb-cancel = "Escape,Control+g,Control+bracketleft,Super+w";
      };
      theme = with config.lib.stylix.colors; let
        # Use `mkLiteral` for string-like values that should show without
        # quotes, e.g.:
        # {
        #   foo = "abc"; => foo: "abc";
        #   bar = mkLiteral "abc"; => bar: abc;
        # };
        inherit (config.lib.formats.rasi) mkLiteral;
      in {
        "*" = {
          bg = mkLiteral "#${base00}";
          al = mkLiteral "#${base04}";
          fg = mkLiteral "#${base07}";
          ac = mkLiteral "#${base0D}";
          se = mkLiteral "#${base02}";
          alternate-normal-background = mkLiteral "@bg";
          alternate-active-background = mkLiteral "@ac";
          alternate-urgent-background = mkLiteral "@bg";
          alternate-normal-foreground = mkLiteral "@fg";
          alternate-active-foreground = mkLiteral "@ac";
          selected-normal-foreground = mkLiteral "@bg";
          selected-normal-background = mkLiteral "@ac";
          selected-active-background = mkLiteral "@ac";
        };

        window = {
          transparency = "real";
          background-color = mkLiteral "@bg";
          text-color = mkLiteral "@fg";
          border = mkLiteral "0px";
          border-color = mkLiteral "@ac";
          border-radius = 4;
        };

        prompt = {
          enabled = true;
          background-color = mkLiteral "@bg";
          text-color = mkLiteral "@fg";
        };

        entry = {
          background-color = mkLiteral "@bg";
          text-color = mkLiteral "@fg";
          placeholder-color = mkLiteral "@fg";
          expand = true;
          horizontal-align = 0;
          placeholder = "Search";
          blink = true;
        };

        inputbar = {
          background-color = mkLiteral "@bg";
          text-color = mkLiteral "@fg";
          expand = false;
          border = mkLiteral "0px";
          margin = mkLiteral "0% 0% 0% 0%";
          padding = mkLiteral "0.5%";
        };

        listview = {
          background-color = mkLiteral "@bg";
          columns = 2;
          cycle = false;
          dynamic = true;
          layout = "vertical";
          border = mkLiteral "0px";
        };

        button = {
          text-color = mkLiteral "@fg";
          horizontal-align = mkLiteral "0.5";
        };

        "button selected" = {
          background-color = mkLiteral "@ac";
          text-color = mkLiteral "@bg";
          border = mkLiteral "0px";
        };

        mainbox = {
          background-color = mkLiteral "@bg";
          border = mkLiteral "0px";
          children = mkLiteral "[ inputbar, listview, mode-switcher ]";
        };

        element = {
          background-color = mkLiteral "@bg";
          text-color = mkLiteral "@fg";
          orientation = mkLiteral "horizontal";
          border = mkLiteral "0px";
          children = mkLiteral "[ element-icon, element-text ]";
        };

        element-icon = {
          background-color = mkLiteral "inherit";
          text-color = mkLiteral "inherit";
        };

        element-text = {
          background-color = mkLiteral "inherit";
          text-color = mkLiteral "inherit";
        };

        "element normal" = {
          background-color = mkLiteral "@bg";
          text-color = mkLiteral "@fg";
          border = mkLiteral "0px";
        };

        "element selected" = {
          background-color = mkLiteral "@ac";
          text-color = mkLiteral "@bg";
          border = mkLiteral "0px";
        };
      };
    };
  };
}
