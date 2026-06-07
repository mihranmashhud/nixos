{
  mm.apps.social.homeManager = {pkgs, ...}: {
    home.packages = with pkgs; [
      slack
      teams-for-linux
      telegram-desktop
      (zoom-us.override (prev: {
        hyprlandXdgDesktopPortalSupport = true;
      }))
    ];
    programs.vesktop.enable = true;
    programs.discord = {
      enable = true;
      settings = {
        SKIP_HOST_UPDATE = true;
      };
    };
  };
}
