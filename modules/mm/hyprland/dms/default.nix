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
    };

    homeManager = {
      pkgs,
      host,
      ...
    }: {
      imports = [
        inputs.dms.homeModules.dank-material-shell
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
        quickshell.package = inputs.quickshell.packages.${pkgs.system}.quickshell;
        enableDynamicTheming = false;
        settings = builtins.fromJSON (builtins.readFile ./settings-${host.device-type}.json);
      };
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
  };
}
