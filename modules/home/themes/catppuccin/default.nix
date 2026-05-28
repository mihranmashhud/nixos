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
  cfg = config.${namespace}.themes.catppuccin;
  theming = config.${namespace}.theming;
  flavor = "mocha";
  accent = "mauve";
in {
  # Currently using catpuccin-mocha theme for the most part.
  options.${namespace}.themes.catppuccin = with types; {
    enable = mkBoolOpt false "Whether to enable catppuccin user theme";
  };

  config = mkIf cfg.enable (mkMerge [
    {
      stylix = {
        autoEnable = false;
        base16Scheme = getScheme pkgs "catppuccin-${flavor}";
        opacity.terminal = 0.8;
      };

      catppuccin.enable = true;
      catppuccin = {
        inherit accent flavor;
      };
      catppuccin.gtk.icon = {
        inherit accent flavor;
      };

      # Disable for these targets
      catppuccin = {
        cursors.enable = false;
        rofi.enable = false;
        nvim.enable = false;
        firefox.profiles.mihranmashhud.enable = false;
        hyprland.enable = false;
      };
    }
    (mkIf theming.graphical {
      gtk = {
        enable = true;
        theme = {
          name = "Catppuccin-GTK-Dark";
          package = pkgs.magnetic-catppuccin-gtk;
        };
        iconTheme = mkForce {
          name = "Papirus";
          package = pkgs.papirus-icon-theme;
        };
      };
    })
    (mkIf config.programs.dank-material-shell.enable {
      programs.dank-material-shell.settings = {
        currentThemeName = "custom";
        currentThemeCategory = "registry";
        customThemeFile = "${config.xdg.configHome}/DankMaterialShell/themes/catppuccin/theme.json";
        registryThemeVariants = {
          catppuccin = {
            inherit accent flavor;
          };
        };
        iconTheme = config.gtk.iconTheme.name;
      };
      xdg.configFile."DankMaterialShell/themes/catppuccin/theme.json".source = ./dms.json;
    })
  ]);
}
