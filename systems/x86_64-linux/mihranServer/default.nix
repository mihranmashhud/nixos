{
  lib,
  pkgs,
  inputs,
  system,
  config,
  ...
}:
with lib;
with lib.internal; {
  imports = [
    ./hardware.nix # Make sure to add the generated hardware config.
  ];

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

  # Secrets
  age.secrets = {
    cloudflared-cert.file = ../../../secrets/cloudflared-cert.age;
    cloudflared-tunnel.file = ../../../secrets/cloudflared-tunnel.age;
  };

  internal.services.cloudflared = {
    enable = true;
    certificateFile = "${config.age.secrets.cloudflared-cert.path}";
    tunnels = {
      "f2e9d477-063c-4eae-8f3d-6eeed5499825" = {
        credentialsFile = "${config.age.secrets.cloudflared-tunnel.path}";
        default = "http_status:404";
        ingress = [
          {
            hostname = "seafile.mihran.dev";
            service = config.services.seafile.seahubAddress;
          }
          {
            hostname = "seafile.mihran.dev";
            service = config.services.seafile.seafileSettings.fileserver.host;
            path = "seafhttp";
          }
        ];
      };
    };
  };

  # environment.etc."nextcloud-admin-pass".text = "Canine-Joyous-Obligate-Mushroom-Laxative5";
  # services.nextcloud = {
  #   enable = true;
  #   occ.enable = true;
  #   package = pkgs.nextcloud31;
  #   hostName = "localhost:8000";
  #   config.adminpassFile = "/etc/nextcloud-admin-pass";
  #   config.dbtype = "sqlite";
  #   settings.trusted_domains = ["nextcloud.mihran.dev" "10.0.0.20:8000"];
  # };
  services.seafile = {
    enable = true;
    seahubAddress = "unix:/run/seahub/gunicorn.sock";
    ccnetSettings.General.SERVICE_URL = "https://seahub.mihran.dev";
    adminEmail = "mihranmashhud@gmail.com";
    initialAdminPassword = "Canine-Joyous-Obligate-Mushroom-Laxative5";
    seafileSettings.fileserver.host = "unix:/run/seafile/server.sock";
  };

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
  services.readarr = {
    enable = true;
    openFirewall = true;
    group = "multimedia";
  };
  services.transmission = {
    enable = true;
    openFirewall = true;
    openRPCPort = true;
    group = "multimedia";
    settings = {
      rpc-bind-address = "0.0.0.0";
      rcp-whitelist = "127.0.0.1:10.0.0.*";
    };
  };

  systemd.services.glances-web-server = {
    wantedBy = ["multi-user.target"];
    after = ["network.target"];
    description = "Start glances web server";
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.glances}/bin/glances -w";
    };
  };
  networking.firewall = {
    allowedTCPPorts = [61208];
  };

  services.homepage-dashboard = {
    enable = true;
    openFirewall = true;
    settings = {
      title = "Mihran's Homelab";
      layout = {
        "Media" = {
          style = "row";
          columns = 5;
        };
      };
    };
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
              href = "http://10.0.0.20:7878";
              description = "Movies management";
            };
          }
          {
            "Sonarr" = {
              icon = "sonarr.png";
              href = "http://10.0.0.20:8989";
              description = "TV shows management";
            };
          }
          {
            "Readarr" = {
              icon = "readarr.png";
              href = "http://10.0.0.20:8787";
              description = "EBooks management";
            };
          }
          {
            "Prowlarr" = {
              icon = "prowlarr.png";
              href = "http://10.0.0.20:9696";
              description = "Torrent indexes";
            };
          }
        ];
      }
      {
        "Info" = [
          {
            "CPU Usage" = {
              widget = {
                type = "glances";
                url = "http://10.0.0.20:61208";
                version = 4;
                metric = "cpu";
              };
            };
          }
          {
            "Memory Usage" = {
              widget = {
                type = "glances";
                url = "http://10.0.0.20:61208";
                version = 4;
                metric = "memory";
              };
            };
          }
          {
            "Storage Usage" = {
              widget = {
                type = "glances";
                url = "http://10.0.0.20:61208";
                version = 4;
                metric = "disk:nvme0n1";
              };
            };
          }
          {
            "Top Processes (by CPU usage)" = {
              widget = {
                type = "glances";
                url = "http://10.0.0.20:61208";
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
      vaapiVdpau
      intel-compute-runtime # OpenCL filter support (hardware tonemapping and subtitle burn-in)
      vpl-gpu-rt # QSV on 11th gen or newer
    ];
  };

  internal = {
    locale = enabled;
    development = {
      direnv = enabled;
      docker = enabled;
      pnpm = enabled;
      ssh = enabled;
    };
  };

  environment.systemPackages = with pkgs; [
    glances
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
