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

      hardware.microsoft-surface.kernelVersion = "stable";
      services.surface-dtx-daemon.enable = true;
      services.xserver.videoDrivers = ["modesetting" "nvidia"];

      boot.extraModprobeConfig = ''
        options nvidia_drm modeset=1
      '';
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
        powerManagement = {
          enable = true;
          finegrained = true;
        };
        nvidiaPersistenced = false;
      };
      services.switcherooControl.enable = true;
      services.udev.packages = [
        self'.packages.sb3-nvidia-pm-udev-rules
      ];
      services.udev.extraRules =
        # udev
        ''
          KERNEL=="card*", KERNELS=="0000:00:02.0", SUBSYSTEM=="drm", SUBSYSTEMS=="pci", SYMLINK+="dri/igpu"
          KERNEL=="card*", KERNELS=="0000:02:00.0", SUBSYSTEM=="drm", SUBSYSTEMS=="pci", SYMLINK+="dri/dgpu"
        '';
      services.iptsd = {
        enable = true;
        config = {
          TouchScreen = {
            DisableOnPalm = true; # Palm rejection
            DisableOnStylus = true; # No touch when stylus
          };
        };
      };
      environment.sessionVariables = {
        VK_LOADER_DRIVERS_DISABLE = "nvidia_icd.json";
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
      wayland.windowManager.hyprland.settings = {
        env = [{_args = ["AQ_DRM_DEVICES" "/dev/dri/igpu"];}];
        monitor = [
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
  };
}
