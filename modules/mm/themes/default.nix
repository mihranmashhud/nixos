{
  mm.themes = {
    meta = {
      getScheme = pkgs: scheme: "${pkgs.base16-schemes}/share/themes/${scheme}.yaml";
    };

    homeManager = {config, ...}: {
      programs.kitty.settings = {
        background_opacity = "${toString config.stylix.opacity.terminal}";
        font_size = "${toString config.stylix.fonts.sizes.terminal}.0";
        font_family = "family=\"${config.stylix.fonts.monospace.name}\"";
      };
    };
  };
}
