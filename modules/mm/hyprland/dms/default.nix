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
          customConfig =
            # lua
            ''
              hl.env("DMS_RUN_GREETER","1")
              hl.env("HYPRCURSOR_THEME","${config.stylix.cursor.name}")
              hl.env("HYPRCURSOR_SIZE","${toString config.stylix.cursor.size}")

              hl.config({
                misc = {
                  disable_hyprland_logo = true,
                  disable_splash_rendering = true,
                  disable_watchdog_warning = true
                }
              })
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
      ...
    }: {
      imports = [
        inputs.dms.homeModules.dank-material-shell
        inputs.dms-plugin-registry.nixosModules.default
        inputs.dcal.homeModules.default
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
        enableDynamicTheming = false;
        settings = builtins.fromJSON (builtins.readFile ./settings-${host.device-type}.json);
        plugins = {
          dankKDEConnect.enable = true;
        };
      };
      programs.dank-calendar = {
        enable = true;
        settings = builtins.fromJSON (builtins.readFile ./dcal-settings.json);
        systemd.enable = true;
      };
      services.kdeconnect.enable = true;
    };
  };
  flake-file.inputs = {
    dms = {
      url = "github:duxlabs-dev/dux-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dms-plugin-registry = {
      url = "github:duxlabs-dev/dux-plugin-registry";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dcal = {
      url = "github:duxlabs-dev/dux-calendar";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
