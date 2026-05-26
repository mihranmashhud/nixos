{
  lib,
  pkgs,
  inputs,
  namespace, # The namespace used for your flake, defaulting to "internal" if not set.
  system, # The system architecture for this host (eg. `x86_64-linux`).
  target, # The Snowfall Lib target for this system (eg. `x86_64-iso`).
  format, # A normalized name for the system target (eg. `iso`).
  virtual, # A boolean to determine whether this system is a virtual target using nixos-generators.
  systems, # An attribute map of your defined hosts.
  config,
  ...
}:
with lib;
with lib.${namespace}; let
  cfg = config.${namespace}.desktop.hyprland;
in {
  options.${namespace}.desktop.hyprland = with types; {
    enable = mkBoolOpt false "Whether to enable hyprland system configuration.";
    makeDefaultSession = mkBoolOpt false "Make it the default session.";
    dmsGreeter = mkBoolOpt false "Use DMS greeter.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      xdg-utils
    ];
    services.udisks2.enable = true; # Required for udiskie
    services.accounts-daemon.enable = true; # For user account information
    programs.hyprland.enable = true;
    services.displayManager = mkMerge [
      (
        mkIf cfg.dmsGreeter {
          dms-greeter = {
            enable = true;
            configHome = "/home/${config.${namespace}.user.name}";
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
        }
      )
      (
        mkIf (!cfg.dmsGreeter) {
          sddm.wayland.enable = true;
          sddm.enable = true;
        }
      )
      (mkIf cfg.makeDefaultSession {
        defaultSession = "hyprland";
      })
    ];
    programs.kdeconnect = {
      enable = true;
      package = pkgs.kdePackages.kdeconnect-kde;
    };

    xdg.portal = {
      enable = true;
      xdgOpenUsePortal = true;
      config.hyprland = {
        default = [
          "hyprland"
          "gtk"
        ];
        "org.freedesktop.impl.portal.FileChooser" = [
          "gtk"
        ];
      };
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
      ];
    };

    ${namespace} = {
      polkit.enable = true;
      theming.graphical = true;
    };
  };
}
