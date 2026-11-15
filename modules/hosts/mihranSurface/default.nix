{
  mm,
  inputs,
  lib,
  ...
}: {
  den.hosts.x86_64-linux.mihranSurface = {
    # Set users
    users.mihranmashhud = {
      fullName = "Mihran Mashhud";
      email = "mihranmashhud@gmail.com";
    };

    device-type = "laptop";
    graphical = true;
  };

  # Host aspect
  den.aspects.mihranSurface = {
    includes = [
      mm.system
      mm.themes.catppuccin
      mm.hyprland
      mm.apps
      mm.gaming
    ];

    provides.to-users = {user, ...}: {
      nixos.users.users.${user.name}.extraGroups = ["surface-control"];
    };

    nixos = {self', ...}: {
      imports = with inputs; [
        nixos-hardware.nixosModules.microsoft-surface-pro-intel
        ./_surface-dtx-daemon
        ./_hardware.nix
      ];

      # Surface Book 3

      # Required for auto D3Cold
      boot.extraModprobeConfig = ''
        options nvidia_drm modeset=0
        options nvidia NVreg_DynamicPowerManagement=0x02
      '';
      hardware.microsoft-surface.kernelVersion = "stable";
      services.surface-dtx-daemon.enable = true;
      services.xserver.videoDrivers = ["modesetting" "nvidia"];

      services.upower.enable = true;
      hardware.nvidia = {
        modesetting.enable = true;
        open = true;
        prime = {
          offload.enable = true;
          offload.enableOffloadCmd = true;
          intelBusId = "PCI:0:2:0";
          nvidiaBusId = "PCI:2:0:0";
        };
      };
      services.udev.packages = [
        self'.packages.sb3-nvidia-pm-udev-rules
      ];
      services.iptsd = {
        enable = true;
        config = {
          TouchScreen = {
            DisableOnPalm = true; # Palm rejection
            DisableOnStylus = true; # No touch when stylus
          };
        };
      };

      security.pam.yubico = {
        enable = true;
        mode = "challenge-response";
        id = ["27757091"];
      };

      services.tailscale = {
        enable = true;
        useRoutingFeatures = "client";
      };
    };

    homeManager = {...}: {
      wayland.windowManager.hyprland.settings.monitor = [
        {
          output = "eDP-1";
          mode = "highrr";
          position = "auto";
          scale = 2;
        }
        {
          output = "";
          mode = "preferred";
          position = "auto";
          scale = 1;
          mirror = "eDP-1";
        }
      ];
    };
  };
}
