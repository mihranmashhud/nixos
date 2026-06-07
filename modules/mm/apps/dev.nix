{
  mm.apps.dev.homeManager = {pkgs, ...}: {
    home.packages = with pkgs; [
      github-desktop
      ungoogled-chromium # For web development
      google-chrome
      bruno # HTTP client
      antares # DB management
    ];
  };
}
