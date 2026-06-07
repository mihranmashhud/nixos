{
  den,
  mm,
  ...
}: {
  # user aspect
  den.aspects.mihranmashhud = {
    includes = [
      den.batteries.primary-user
      (den.batteries.user-shell "zsh")

      mm.cli
      mm.dev
    ];

    homeManager = {config, ...}: {
      home.file.".face".source = ../../assets/profile.png;
      home.sessionVariables = {
        BROWSER = "zen-beta";
      };
      xdg.userDirs = {
        enable = true;
        createDirectories = true;
        setSessionVariables = true;
        extraConfig = {
          SCREENSHOTS = "${config.home.homeDirectory}/Pictures/Screenshots";
        };
      };
      wayland.windowManager.hyprland.extraConfig = mm.hyprland.meta.helpers.autostart [
        "vesktop"
        "Telegram"
      ];
    };

    provides.to-hosts.nixos = {pkgs, ...}: {
      environment.systemPackages = with pkgs; [
        git
        curl
        wget
        killall
      ];

      users.users.mihranmashhud = {
        description = "Mihran Mashhud";
        uid = 1000;
        initialPassword = "password";
      };

      services.displayManager.dms-greeter.configHome = "/home/mihranmashhud";
    };
  };
}
