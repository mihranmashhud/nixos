{mm, ...}: {
  den.hosts.x86_64-linux.mihranWSL = {
    # Set users
    users.mihranmashhud = {
      fullName = "Mihran Mashhud";
      email = "mihranmashhud@gmail.com";
    };

    device-type = "server";
    graphical = false;

    wsl.enable = true;
  };
  den.aspects.mihranWSL = {
    includes = [
      mm.themes.catppuccin
    ];
    nixos = {
      wsl = {
        docker-desktop.enable = true;
        startMenuLaunchers = true;
      };
    };
  };
}
