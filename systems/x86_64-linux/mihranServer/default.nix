{
  lib,
  pkgs,
  inputs,
  system,
  config,
  ...
}:
with lib;
with lib.internal; let
in {
  imports = [
    ./hardware.nix # Make sure to add the generated hardware config.
  ];

  internal = {
    locale = enabled;
    development = {
      direnv = enabled;
      docker = enabled;
      pnpm = enabled;
      ssh = enabled;
    };
    server.deploy = {
      enable = true;
      keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDFKRlKNZ6jdiQoT92DBEvHrhnFHd2PhOFapxHX4Wz2B mihranmashhud@mihranDesktop"];
    };
  };

  time.timeZone = "America/Toronto";

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Wifi card keeps spamming errors so I disabled it.
  boot.blacklistedKernelModules = ["rtw88_8821ce"];

  services.getty.autologinUser = "mihranmashhud";

  # Security
  services.openssh.settings = {
    PasswordAuthentication = false;
    TCPKeepAlive = "yes";
    ClientAliveInterval = 300;
    ClientAliveCountMax = 2;
  };
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "server";
    extraSetFlags = ["--advertise-exit-node"];
    extraUpFlags = ["--ssh"];
  };
  system.activationScripts."tailscale-udp-gro-forwarding".text = ''
    ${getExe pkgs.ethtool} -K enp2s0 rx-udp-gro-forwarding on rx-gro-list off
  '';

  # Reverse Proxy
  age.secrets.caddy = {
    file = ../../../secrets/caddy.env.age;
    owner = "caddy";
    group = "caddy";
  };
  services.caddy = {
    enable = true;
    package = pkgs.caddy.withPlugins {
      plugins = ["github.com/caddy-dns/cloudflare@v0.2.2"];
      hash = "sha256-6b1AWcE0P498h6p3b0y/9P0CdGytrwXSyvPkEQq2CVw=";
    };
    extraConfig = ''
      (cloudflare) {
        tls {
          dns cloudflare {$CF_API_TOKEN}
        }
      }
    '';
    environmentFile = config.age.secrets.caddy.path;
    virtualHosts = mkMerge [
      (mkIf config.services.jellyfin.enable {
        "jellyfin.server.mihran.dev".extraConfig = ''
          reverse_proxy http://localhost:8096
          import cloudflare
        '';
      })
      (mkIf config.services.calibre-web.enable {
        "calibre.server.mihran.dev".extraConfig = let
          inherit (config.services.calibre-web.listen) ip port;
        in ''
          reverse_proxy http://${ip}:${toString port}
          import cloudflare
        '';
      })
      (mkIf config.services.n8n.enable {
        "n8n.server.mihran.dev".extraConfig = ''
          reverse_proxy http://localhost:${toString config.services.n8n.environment.N8N_PORT}
          import cloudflare
        '';
      })
      (mkIf config.services.couchdb.enable {
        "couchdb.server.mihran.dev".extraConfig = ''
          reverse_proxy http://localhost:${toString config.services.couchdb.port}
          import cloudflare
        '';
      })
      (mkIf config.services.immich.enable {
        "immich.server.mihran.dev".extraConfig = ''
          reverse_proxy http://localhost:${toString config.services.immich.port}
          import cloudflare
        '';
      })
      (mkIf config.services.syncthing.enable {
        "syncthing.server.mihran.dev".extraConfig = ''
          reverse_proxy http://${config.services.syncthing.guiAddress}
          import cloudflare
        '';
      })
      (mkIf config.services.adguardhome.enable {
        "adguard.server.mihran.dev".extraConfig = let
            inherit (config.services.adguardhome) host port;
          in ''
          reverse_proxy http://${host}:${toString port}
          import cloudflare
        '';
      })
    ];
  };
  networking.firewall.allowedTCPPorts = [80 443];

  # Multimedia
  systemd.tmpfiles.rules = [
    "d /data/media 0770 - multimedia - -"
  ];
  users.groups.multimedia = {};
  users.users.mihranmashhud.extraGroups = [
    "multimedia"
  ];
  services.jellyfin = {
    enable = true;
    openFirewall = true;
    group = "multimedia";
  };
  services.radarr = {
    enable = true;
    openFirewall = true;
    group = "multimedia";
  };
  services.sonarr = {
    enable = true;
    openFirewall = true;
    group = "multimedia";
  };
  services.prowlarr = {
    enable = true;
    openFirewall = true;
  };
  services.calibre-web = {
    enable = true;

    # This is so that the server is accessible via local home network. The e-reader basically requires this if tailscale is to not be installed on it.
    openFirewall = true;
    listen.ip = "10.0.0.20"; # Fixed IP on home network

    group = "multimedia";
    dataDir = "/data/media/calibre-web";
    options = {
      enableBookUploading = true;
    };
  };

  services.transmission = {
    package = pkgs.transmission_4;
    enable = true;
    openFirewall = true;
    openRPCPort = true;
    group = "multimedia";
    settings = {
      rpc-bind-address = "0.0.0.0";
      rcp-whitelist = "127.0.0.1:10.0.0.*";
    };
  };

  # General file sync
  services.syncthing = {
    enable = true;
    guiAddress = "10.0.0.20:8384";
  };

  # Automation
  services.n8n = {
    enable = true;
  };

  # For syncing obsidian
  services.couchdb = {
    enable = true;
    adminPass = "somerandompassword";
  };

  # Photos sync
  services.immich = {
    enable = true;
    accelerationDevices = [
      "/dev/dri/renderD128"
    ];
  };

  # View system load
  services.glances = {
    enable = true;
    extraArgs = [
      "--webserver"
      "--disable-webui"
    ];
  };

  services.adguardhome = {
    enable = true;
    port = 3003;
    openFirewall = true;
    allowDHCP = true;
  };

  services.homepage-dashboard = {
    enable = true;
    openFirewall = true;
    allowedHosts = "10.0.0.20:8082,localhost,homepage.server.mihran.dev";
    services = [
      {
        "Media" = [
          {
            "Jellyfin" = {
              icon = "jellyfin.png";
              href = "http://10.0.0.20:8096";
              description = "Media server";
            };
          }
          {
            "Radarr" = {
              icon = "radarr.png";
              href = "http://10.0.0.20:${toString config.services.radarr.settings.server.port}";
              description = "Movies management";
            };
          }
          {
            "Sonarr" = {
              icon = "sonarr.png";
              href = "http://10.0.0.20:${toString config.services.sonarr.settings.server.port}";
              description = "TV shows management";
            };
          }
          {
            "Prowlarr" = {
              icon = "prowlarr.png";
              href = "http://10.0.0.20:${toString config.services.prowlarr.settings.server.port}";
              description = "Torrent indexes";
            };
          }
          {
            "Calibre Web" = {
              icon = "calibre-web.png";
              href = "http://10.0.0.20:${toString config.services.calibre-web.listen.port}";
              description = "Ebooks Management";
            };
          }
        ];
      }
      {
        "Info" = let
          url = "http://10.0.0.20:${toString config.services.glances.port}";
        in [
          {
            "CPU Usage" = {
              widget = {
                type = "glances";
                inherit url;
                version = 4;
                metric = "cpu";
              };
            };
          }
          {
            "Memory Usage" = {
              widget = {
                type = "glances";
                inherit url;
                version = 4;
                metric = "memory";
              };
            };
          }
          {
            "Storage Usage" = {
              widget = {
                type = "glances";
                inherit url;
                version = 4;
                metric = "disk:nvme0n1";
              };
            };
          }
          {
            "Top Processes (by CPU usage)" = {
              widget = {
                type = "glances";
                inherit url;
                version = 4;
                metric = "process";
              };
            };
          }
        ];
      }
    ];
  };

  # Hardware acceleration
  nixpkgs.config.packageOverrides = pkgs: {
    vaapiIntel = pkgs.vaapiIntel.override {enableHybridCodec = true;};
  };

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      intel-vaapi-driver
      libva-vdpau-driver
      intel-compute-runtime # OpenCL filter support (hardware tonemapping and subtitle burn-in)
      vpl-gpu-rt # QSV on 11th gen or newer
    ];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "26.05"; # Did you read the comment?
}
