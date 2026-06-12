{
  mm,
  inputs,
  ...
}: {
  den.hosts.x86_64-linux.mihranDesktop = {
    # Set users
    users.mihranmashhud = {
      fullName = "Mihran Mashhud";
      email = "mihranmashhud@gmail.com";
    };

    device-type = "desktop";
    graphical = true;
  };

  # Host aspect
  den.aspects.mihranDesktop = {
    inludes = [
      mm.themes.catppuccin
      mm.hyprland
      mm.apps
      mm.gaming
      # (mm.gpu-passthrough {
      #   platform = "amd";
      #   vfioIDs = [
      #     "1002:699f"
      #     "1002:aae0"
      #   ];
      # })
    ];

    nixos = {pkgs, ...}: {
      imports = with inputs; [
        nixos-hardware.nixosModules.common-cpu-amd
        nixos-hardware.nixosModules.common-cpu-amd-pstate
        nixos-hardware.nixosModules.common-gpu-amd
        nixos-hardware.nixosModules.common-pc-ssd
        ./_hardware.nix
      ];

      # Kernel
      boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;

      # Security
      services.openssh.settings = {
        PasswordAuthentication = false;
        TCPKeepAlive = "yes";
        ClientAliveInterval = 300;
        ClientAliveCountMax = 2;
      };
      services.tailscale = {
        enable = true;
        useRoutingFeatures = "client";
        extraUpFlags = ["--ssh"];
      };

      environment.systemPackages = with pkgs; [
        oversteer
        dolphin-emu # Wii/Gamecube emulation
        steam-rom-manager
        heroic
        sidequest
        r2modman
        lm_sensors
        owmods-cli
        ringracers
      ];

      networking.firewall.allowedUDPPorts = [
        5029 # Ring racers
      ];

      networking.interfaces.enp4s0.wakeOnLan = {
        enable = true;
      };

      hardware.amdgpu.overdrive.enable = true;

      programs.gamemode.settings = {
        general = {
          renice = 10;
        };

        gpu = {
          apply_gpu_optimisations = "accept-responsibility";
          gpu_device = 1;
          amd_performance_level = "high";
        };
      };

      programs.coolercontrol.enable = true;

      services.hardware.openrgb = {
        enable = true;
        motherboard = "amd";
      };

      services.pipewire.wireplumber.extraConfig = {
        wireplumber.settings = {
          device.routes.default-sink-volume = 1;
          device.routes.default-source-volume = 1;
        };
        lowLatency = {
          enable = true;
          quantum = 32;
          rate = 48000;
        };
      };

      security.pam.yubico = {
        enable = true;
        mode = "challenge-response";
        id = ["27757091"];
      };

      services.udev.packages = with pkgs; [
        dolphin-emu
      ];

      services.nix-serve = {
        enable = true;
        package = pkgs.nix-serve-ng;
        openFirewall = true;
      };

      nix.settings = {
        cores = 8;
        max-jobs = 8;
        trusted-users = ["nixremote"]; # For using this machine as a remote builder
      };
    };

    provides.to-users = {user, ...}: {
      nixos = {
        services.syncthing = {
          enable = true;
          group = "users";
          user = user.name;
          dataDir = "/home/${user.name}/Documents";
        };
      };
    };
  };
}
