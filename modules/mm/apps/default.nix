{mm, ...}: {
  mm.apps.includes = [mm.apps._];

  mm.apps.localsend.nixos = {
    programs.localsend = {
      enable = true;
      openFirewall = true;
    };
  };
}
