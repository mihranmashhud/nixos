{
  inputs,
  lib,
  ...
}: {
  mm.hyprland.dms = {
    nixos = {config, ...}: {
      services.displayManager.dms-greeter = {
        enable = true;
        compositor = {
          name = "hyprland";
          customConfig = ''
            env = DMS_RUN_GREETER,1
            env = HYPRCURSOR_THEME,${config.stylix.cursor.name}
            env = HYPRCURSOR_SIZE,${toString config.stylix.cursor.size}

            misc {
              disable_hyprland_logo = true
              disable_splash_rendering = true
              disable_watchdog_warning = true
            }
          '';
        };

        logs = {
          save = true;
          path = "/tmp/dms-greeter.log";
        };
      };
      programs.kdeconnect.enable = true;
    };
    provides.to-users = {user, ...}:
      lib.mkIf (user.name == "mihranmashhud") {
        nixos.services.displayManager.dms-greeter.configHome = "/home/mihranmashhud";
      };

    homeManager = {
      pkgs,
      host,
      inputs',
      ...
    }: {
      imports = [
        inputs.dms.homeModules.dank-material-shell
        inputs.dms-plugin-registry.nixosModules.default
      ];

      home.packages = with pkgs; [
        kdePackages.qt6ct
      ];
      qt = {
        enable = true;
        style.name = "kvantum";
        platformTheme.name = "qt6ct";
      };
      programs.dank-material-shell = {
        enable = true;
        quickshell.package = inputs'.quickshell.packages.quickshell;
        enableDynamicTheming = false;
        settings = builtins.fromJSON (builtins.readFile ./settings-${host.device-type}.json);
        plugins = {
          dankKDEConnect.enable = true;
        };
      };
      services.kdeconnect.enable = true;
    };
  };
  flake-file.inputs = {
    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dms = {
      url = "github:AvengeMedia/DankMaterialShell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dms-plugin-registry = {
      url = "github:AvengeMedia/dms-plugin-registry";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
