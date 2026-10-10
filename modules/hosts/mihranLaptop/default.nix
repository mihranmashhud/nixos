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
      mm.gaming.stream-client
    ];

    nixos = {
      imports = with inputs; [
        nixos-hardware.nixosModules.lenovo-thinkpad-t480
        ./_hardware.nix
      ];

      services.upower.enable = true;
      services.libinput.enable = true; # Enable touchpad support
      services.tlp.enable = true;

      security.pam.yubico = {
        enable = true;
        mode = "challenge-response";
        id = ["27757091"];
      };

      services.tailscale = {
        enable = true;
        useRoutingFeatures = "client";
      };

      # Distributed Nix builds
      nix.buildMachines = [
        {
          hostName = "builder";
          system = "x86_64-linux";
          protocol = "ssh-ng";
          maxJobs = 3;
          speedFactor = 2;
          supportedFeatures = ["nixos-test" "benchmark" "big-parallel" "kvm"];
          mandatoryFeatures = [];
        }
      ];
      nix.distributedBuilds = true;
      nix.settings = {
        builders-use-substitutes = true;
      };
    };

    homeManager = {pkgs, ...}: {
      wayland.windowManager.hyprland.settings.monitor = [
        {
          output = "eDP-1";
          mode = "highrr";
          position = "auto";
          scale = 1;
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
