{
  mm,
  lib,
  ...
}: {
  mm.system = {
    includes = [
      mm.system.boot
      mm.system.network
      mm.system.sound
      mm.system.printer
      mm.system.udev
      mm.system.bluetooth
      mm.system.drawingtablet
    ];

    boot.nixos = {config, ...}: {
      boot = {
        loader = {
          efi = {
            canTouchEfiVariables = true;
            efiSysMountPoint = "/boot/efi";
          };
          grub = {
            enable = true;
            copyKernels = true;
            device = "nodev";
            efiSupport = true;
            configurationLimit = 5;
            useOSProber = true;
          };
          timeout = 10;
        };
        # TODO: Add to theme aspect instead
        kernelParams = lib.mkIf config.boot.plymouth.enable [
          # Silent Boot Params
          "quiet"
          "splash" # See splash screen
          "rd.systemd.show_status=false"
          "rd.udev.log_level=3"
          "udev.log_priority=3"
          "boot.shell_on_fail"
        ];
      };
    };

    fonts.nixos = {pkgs, ...}: {
      environment.systemPackages = with pkgs;
        lib.mkIf host.graphical [
          gnome-font-viewer
        ];
      fonts.packages = with pkgs; [
        garamond-libre
        liberation_ttf
        google-fonts
        corefonts
      ];
      provides.to-hosts = {host, ...}: {
        environment.systemPackages = with pkgs;
          lib.mkIf host.graphical [
            gnome-font-viewer
          ];
      };
    };

    locale.nixos = {
      # Select internationalisation properties.
      i18n = rec {
        defaultLocale = "en_US.UTF-8";
        extraLocaleSettings = {
          LC_ADDRESS = defaultLocale;
          LC_IDENTIFICATION = defaultLocale;
          LC_MEASUREMENT = defaultLocale;
          LC_MONETARY = defaultLocale;
          LC_NAME = defaultLocale;
          LC_NUMERIC = defaultLocale;
          LC_PAPER = defaultLocale;
          LC_TELEPHONE = defaultLocale;
          LC_TIME = defaultLocale;
        };
      };
    };

    network = {
      nixos = {
        networking.networkmanager.enable = true;
        networking.firewall.enable = true;
        programs.nm-applet.enable = true;
        services.automatic-timezoned.enable = true;
      };
      provides.to-users = {user, ...}: {
        nixos.users.users.${user.name}.extraGroups = ["networkmanager"];
      };
    };

    sound.nixos = {
      security.rtkit.enable = true;
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
      };
    };

    printer = {user, ...}: {
      nixos = {pkgs, ...}: {
        # Printing
        services.printing.enable = true;
        services.avahi = {
          enable = true;
          nssmdns4 = true;
          openFirewall = true;
        };
        # Load epson driver
        services.printing.drivers = with pkgs; [
          epson-escpr2
        ];
        # Scanning
        hardware.sane = {
          enable = true;
          extraBackends = with pkgs; [
            sane-airscan
          ];
          openFirewall = true;
        };
        environment.systemPackages = with pkgs; [
          simple-scan
        ];
        services.ipp-usb.enable = true;
        # Add to relevant groups
      };
      users.users.${user.name}.extraGroups = [
        "scanner"
        "lp"
      ];
    };

    udev.nixos = {
      pkgs,
      self',
      ...
    }: {
      services.udev.packages = with pkgs;
      with self'.packages; [
        qmk-udev-rules
        vial-udev-rules
        g920-wheel-udev-rules
        dualsense-udev-rules
      ];
    };

    bluetooth.nixos = {
      hardware.bluetooth = {
        powerOnBoot = true;
        enable = true;
        settings = {
          General = {
            Experimental = true;
            # JustWorksRepairing = "always";
            # FastConnectable = true;
            # Class = "0x000100";
          };
          # GATT = {
          #   ReconnectIntervals = "1,1,2,3,5,8,13,21,34,55";
          #   AutoEnable = true;
          # };
          Policy = {
            AutoEnable = true;
          };
        };
        # input = {
        #   General = {
        #     UserspaceHID = true;
        #   };
        # };
      };
    };

    drawingtablet.nixos = {
      hardware.opentabletdriver = {
        enable = true;
        daemon.enable = true;
      };
    };
  };
}
