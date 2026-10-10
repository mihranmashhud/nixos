{
  mm,
  inputs,
  lib,
  ...
}: {
  mm.themes.catppuccin = let
    flavor = "mocha";
    accent = "mauve";
  in {
    includes = [
      mm.themes
      mm.themes.catppuccin._
    ];

    nixos = {
      pkgs,
      host,
      config,
      ...
    }: {
      imports = with inputs; [
        stylix.nixosModules.stylix
        catppuccin.nixosModules.catppuccin
      ];

      stylix = {
        enable = true;
        autoEnable = false;
        base16Scheme = mm.themes.meta.getScheme pkgs "catppuccin-${flavor}";
        opacity.terminal = 0.8;
        cursor = lib.mkIf host.graphical {
          package = pkgs.bibata-cursors;
          name = "Bibata-Modern-Classic";
          size = 24;
        };
      };

      catppuccin = {
        enable = true;
        cache.enable = true;
        autoEnable = true;
        inherit accent flavor;
        sources = inputs.catppuccin.packages.${pkgs.stdenv.hostPlatform.system}.overrideScope (final: prev: {
          whiskers = pkgs.catppuccin-whiskers;
        });
      };
      services.displayManager.sddm.package = pkgs.kdePackages.sddm;
      boot = {
        plymouth.enable = host.graphical;
        kernelParams = lib.mkIf host.graphical [
          # Silent Boot Params
          "quiet"
          "splash" # See splash screen
          "rd.systemd.show_status=false"
          "rd.udev.log_level=3"
          "udev.log_priority=3"
          "boot.shell_on_fail"
        ];
      };
      environment.sessionVariables = lib.mkIf (host.graphical && config.programs.hyprland.enable) {
        HYPRCURSOR_THEME = config.stylix.cursor.name;
        HYPRCURSOR_SIZE = toString config.stylix.cursor.size;
      };
    };

    homeManager = {pkgs, ...}: {
      imports = with inputs; [
        catppuccin.homeModules.catppuccin
      ];

      stylix = {
        autoEnable = false;
        base16Scheme = mm.themes.meta.getScheme pkgs "catppuccin-${flavor}";
        opacity.terminal = 0.8;
      };

      catppuccin = {
        enable = true;
        autoEnable = true;
        inherit accent flavor;
        gtk.icon = {
          inherit accent flavor;
        };

        cursors.enable = false;
        rofi.enable = false;
        nvim.enable = false;
        hyprland.enable = false;
        sources = inputs.catppuccin.packages.${pkgs.stdenv.hostPlatform.system}.overrideScope (final: prev: {
          whiskers = pkgs.catppuccin-whiskers;
        });
      };
      gtk = rec {
        enable = true;
        theme = {
          name = "Catppuccin-GTK-Dark";
          package = pkgs.magnetic-catppuccin-gtk;
        };
        gtk4 = {
          inherit theme;
        };
      };
    };
  };

  flake-file.inputs = {
    stylix.url = "github:danth/stylix";
    catppuccin.url = "github:catppuccin/nix";
  };
}
