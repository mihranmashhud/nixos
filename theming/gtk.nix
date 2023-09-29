{ config, pkgs, ... }: {
  gtk = {
    enable = true;
    cursorTheme = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
    };
    theme = {
      package = (pkgs.colloid-gtk-theme.override {
        tweaks = [
          "black"
          "rimless"
        ];
      });
      name = "Colloid-Dark";
    };
    iconTheme = {
      package = pkgs.fluent-icon-theme;
      name = "Fluent";
    };
  };
}
