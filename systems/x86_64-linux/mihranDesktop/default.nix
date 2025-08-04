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
    ./hardware.nix
  ];

  # Kernel
  boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;

  internal = {
    system = enabled;

    apps.steam.enable = true;

    development = enabled;

    desktop.hyprland = enabled;

    gpu-passthrough = {
      enable = true;
      platform = "amd";
      vfioIDs = [
        "1002:699f"
        "1002:aae0"
      ];
    };
  };

  # Security
  services.openssh.settings = {
    PasswordAuthentication = false;
    TCPKeepAlive = "yes";
    ClientAliveInterval = 300;
    ClientAliveCountMax = 2;
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
    linux-wallpaperengine
  ];

  networking.interfaces.enp4s0.wakeOnLan = {
    enable = true;
  };

  hardware.amdgpu.overdrive.enable = true;

  services.wivrn = {
    enable = true;
    openFirewall = true;
    autoStart = true;
    config = {
      enable = true;
      json = {
        scale = 0.5;
        bitrate = 50000000;
        encoders = [
          {
            encoder = "vaapi";
            codec = "h265";
            width = 1.0;
            height = 1.0;
            offset_x = 0.0;
            offset_y = 0.0;
          }
        ];
        application = [pkgs.wlx-overlay-s];
      };
    };
  };

  programs.alvr = {
    enable = true;
    openFirewall = true;
  };

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
  };

  services.pipewire.lowLatency = {
    enable = true;
    quantum = 32;
    rate = 48000;
  };

  security.rtkit = enabled;

  security.pam.yubico = {
    enable = true;
    mode = "challenge-response";
    id = ["27757091"];
  };

  services.udev.packages = with pkgs;
  with pkgs.internal; [
    yklock-udev-rules
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

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
