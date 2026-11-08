{
  mm.apps.dev.homeManager = {pkgs, ...}: {
    home.packages = with pkgs; [
      github-desktop
      bruno # HTTP client
      antares # DB management
    ];
  };
}
