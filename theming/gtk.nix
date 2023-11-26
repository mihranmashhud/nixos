{
  config,
  pkgs,
  ...
}: rec {
  gtk = {
    enable = true;
    cursorTheme = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
    };
    theme = {
      package = pkgs.colloid-gtk-theme.override {
        tweaks = [
          "black"
          "rimless"
        ];
      };
      name = "Colloid-Dark";
    };
    iconTheme = {
      package = pkgs.fluent-icon-theme;
      name = "Fluent";
    };
  };
  home.pointerCursor = {
    gtk.enable = true;
    package = gtk.cursorTheme.package;
    name = gtk.cursorTheme.name;
    size = 24;
  };
}
