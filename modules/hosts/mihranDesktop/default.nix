{
  mm,
  inputs,
  lib,
  ...
}: {
  den.hosts.x86_64-linux.mihranDesktop = {
    # Set users
    users.mihranmashhud = {
      fullName = "Mihran Mashhud";
      email = "mihranmashhud@gmail.com";
    };

    device-type = "desktop";
  };

  # Host aspect
  den.aspects.mihranDesktop = {
    includes = [
      mm.system
      mm.themes.catppuccin
      mm.hyprland
      mm.apps
      mm.gaming
      (mm.gpu-passthrough {
        platform = "amd";
        vfioIDs = [
          "1002:699f"
          "1002:aae0"
        ];
      })
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

    homeManager = {pkgs, ...}: {
      wayland.windowManager.hyprland = with mm.hyprland.meta.helpers; {
        settings = let
          m1 = "desc:Acer Technologies XB253Q TH5AA0038521";
          m2 = "desc:Sceptre Tech Inc Sceptre M24 0x00000001";
        in {
          monitor = [
            {
              output = m1;
              mode = "highrr";
              vrr = 1;
              cm = "auto";
              supports_wide_color = -1;
              supports_hdr = 1;
              sdrbrightness = 1.0;
              sdrsaturation = 1.0;
              sdr_min_luminance = 0.005;
              sdr_max_luminance = 200;
              min_luminance = 0;
              max_luminance = 400;
            }
            {
              output = m2;
              mode = "highrr";
              position = "auto-right";
              vrr = 0;
            }
          ];
          config = {
            general = {
              allow_tearing = true;
            };
            render = {
              direct_scanout = 2;
            };
          };
          workspace_rule =
            monitor_workspaces m1 (map toString (lib.lists.range 1 5))
            ++ monitor_workspaces m2 (map toString (lib.lists.range 6 10));
        };
        extraConfig = lib.mkMerge [
          # lua
          ''
            hl.curve("linear", { type = "bezier", points = {{0.0,0.0},{1.0,1.0}}})
            hl.animation({ leaf = "borderangle", enabled = true, speed = 0.1, bezier = "linear", style = "loop"})
          ''
          (autostart [
            "${pkgs.openrgb}/bin/openrgb -p 'cool ice'"
          ])
        ];
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
