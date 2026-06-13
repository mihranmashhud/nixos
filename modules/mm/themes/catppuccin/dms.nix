{lib, ...}: {
  mm.themes.catppuccin.dms = let
    flavor = "mocha";
    accent = "mauve";
  in {
    homeManager = {config, ...}: (lib.mkIf (builtins.hasAttr "dank-material-shell" config.programs) {
      programs.dank-material-shell.settings = lib.mkForce {
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
      xdg.configFile."DankMaterialShell/themes/catppuccin/theme.json".source = ./dms-theme.json;
    });
  };
}
