{
  mm.apps.social.homeManager = {pkgs, ...}: {
    home.packages = with pkgs; [
      telegram-desktop
      (zoom-us.override (_prev: {
        hyprlandXdgDesktopPortalSupport = true;
      }))
    ];
    programs.vesktop.enable = true;
  };
}
