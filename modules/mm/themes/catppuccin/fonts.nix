{
  mm.themes.catppuccin.fonts.nixos = {pkgs, ...}: {
    fonts.packages = with pkgs.nerd-fonts; [
      fira-code
      hasklug
      iosevka
      victor-mono
      symbols-only
    ];
    stylix.fonts = {
      sizes = {
        applications = 12;
        desktop = 10;
        popups = 10;
        terminal = 12;
      };
      sansSerif = {
        package = pkgs.inter;
        name = "Inter";
      };
      serif = {
        package = pkgs.roboto-slab;
        name = "Roboto Slab";
      };
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrains Mono";
      };
    };
  };
}
