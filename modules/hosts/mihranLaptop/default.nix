{
  mm,
  inputs,
  ...
}: {
  den.hosts.x86_64-linux.mihranLaptop = {
    # Set users
    users.mihranmashhud = {
      fullName = "Mihran Mashhud";
      email = "mihranmashhud@gmail.com";
    };

    device-type = "laptop";
    graphical = true;
  };

  # Host aspect
  den.aspects.mihranLaptop = {
    includes = [
      mm.system
      mm.themes.catppuccin
      mm.hyprland
      mm.apps
      mm.gaming
    ];

    nixos = {
      pkgs,
      self',
      ...
    }: {
      imports = with inputs; [
        nixos-hardware.nixosModules.microsoft-surface-common
        ./_hardware.nix
      ];

      # Surface Book 3

      boot.kernelParams = [
        "reboot=pci"
      ];
      boot.initrd.kernelModules = [
        "surface_aggregator"
        "surface_aggregator_registry"
        "surface_aggregator_hub "
        "surface_hid_core"
        "surface_hid"
        "intel_lpss"
        "intel_lpss_pci"
        "8250_dw"
      ];
      boot.extraModprobeConfig = ''
        # Required for auto D3Cold
        options nvidia_drm modeset=0
        options nvidia NVreg_DynamicPowerManagement=0x02
      '';
      hardware.microsoft-surface.kernelVersion = "stable";
      hardware.graphics.enable = true;
      services.xserver.videoDrivers = ["nvidia"];
      hardware.nvidia = {
        modesetting.enable = true;
        open = true;
        prime = {
          # TODO: Change the bus IDs to the ones on the device.

          offload.enable = true;
          offload.enableOffloadCmd = true;
          # intelBusId = "PCI:0@0:2:0";
          # nvidiaBusId = "PCI:1@0:0:0";
        };
      };
      environment.systemPackages = with pkgs; [
        surface-control
      ];
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
        # TODO: Change these to match the laptop (output and mirror)
        # {
        #   output = "eDP-1";
        #   mode = "highrr";
        #   position = "auto";
        #   scale = 1;
        # }
        # {
        #   output = "";
        #   mode = "preferred";
        #   position = "auto";
        #   scale = 1;
        #   mirror = "eDP-1";
        # }
      ];
    };
  };
}
