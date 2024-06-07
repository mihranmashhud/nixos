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
  cfg = config.${namespace}.apps.wlogout;
in {
  options.${namespace}.apps.wlogout = {
    enable = mkBoolOpt false "Whether to enable wlogout configuration.";
  };
  config = mkIf cfg.enable {
    programs.wlogout = {
      enable = true;
      layout = [
        {
          "label" = "lock";
          "action" = "hyprlock";
          "text" = "Lock";
          "keybind" = "l";
        }
        {
          "label" = "hibernate";
          "action" = "systemctl hibernate";
          "text" = "Hibernate";
          "keybind" = "h";
        }
        {
          "label" = "logout";
          "action" = "hyprctl dispatch exit";
          "text" = "Logout";
          "keybind" = "e";
        }
        {
          "label" = "shutdown";
          "action" = "systemctl poweroff";
          "text" = "Shutdown";
          "keybind" = "s";
        }
        {
          "label" = "suspend";
          "action" = "systemctl suspend";
          "text" = "Suspend";
          "keybind" = "u";
        }
        {
          "label" = "reboot";
          "action" = "systemctl reboot";
          "text" = "Reboot";
          "keybind" = "r";
        }
      ];
      style = with config.lib.stylix.colors;
      /*
      css
      */
        ''
          * {
            background-image: none;
          }
          window {
            background-color: #${base00};
          }
          button {
            color: #${base07};
            background-color: #${base02};
            border-style: solid;
            border-width: 2px;
            background-repeat: no-repeat;
            background-position: center;
            background-size: 25%;
          }

          button:focus, button:active, button:hover {
            background-color: #${base0D};
            outline-style: none;
          }

          #lock {
              background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/lock.png"));
          }

          #logout {
              background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/logout.png"));
          }

          #suspend {
              background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/suspend.png"));
          }

          #hibernate {
              background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/hibernate.png"));
          }

          #shutdown {
              background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/shutdown.png"));
          }

          #reboot {
              background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/reboot.png"));
          }
        '';
    };
  };
}
