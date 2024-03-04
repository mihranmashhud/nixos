{
  config,
  pkgs,
  inputs,
  ...
}: {
  # Console
  console = {
    font = "ter-132n";
    packages = with pkgs; [
      terminus_font
    ];
  };

  #TTY
  services.kmscon = {
    enable = true;
    hwRender = true;
    extraConfig = ''
      font-name=CaskaydiaCove Nerd Font
      font-size=12
    '';
  };

  # Boot
  boot = {
    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };
      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        configurationLimit = 5;
        useOSProber = true;
      };
      timeout = 10;
    };
    # Plymouth with silent boot
    consoleLogLevel = 0;
    initrd.verbose = false;
    plymouth = let
      theme = "circle_hud";
    in {
      enable = true;
      themePackages = with pkgs; [
        (adi1090x-plymouth-themes.override {
          selected_themes = [
            theme
          ];
        })
      ];
      inherit theme;
    };
    kernelParams = [
      # Silent Boot Params
      "quiet"
      "splash" # See splash screen
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
      "boot.shell_on_fail"
    ];
  };

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  # time.timeZone = "America/Toronto";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Polkit auth agent
  systemd = {
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = ["graphical-session.target"];
      wants = ["graphical-session.target"];
      after = ["graphical-session.target"];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };

  services.gnome.gnome-keyring.enable = true;

  services.gvfs.enable = true;

  # services.xserver.desktopManager.gnome.enable = true;

  services.xserver = {
    enable = true;
    displayManager = {
      sddm.enable = true;
      sddm.theme = "${import ../theming/sddm-chili.nix {inherit pkgs;}}";
      sddm.settings = {
        Theme = {
          EnableAvatars = true;
          DisableAvatarsThreshold = 7;
        };
      };
    };
  };
  # Set default apps here
  xdg.mime.defaultApplications = {
    "application/pdf" = "firefox.desktop";
    "text/html" = "firefox.desktop";
    "x-scheme-handler/http" = "firefox.desktop";
    "x-scheme-handler/https" = "firefox.desktop";
    "x-scheme-handler/about" = "firefox.desktop";
    "x-scheme-handler/unknown" = "firefox.desktop";
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
  };

  services.automatic-timezoned.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Printing
  services.printing.enable = true;
  services.avahi.enable = true;
  services.avahi.nssmdns4 = true;
  # for WiFi printer
  services.avahi.openFirewall = true;
  # Load epson driver
  services.printing.drivers = with pkgs; [
    epson-escpr
  ];

  # Scanning
  hardware.sane = {
    enable = true;
    extraBackends = [pkgs.sane-airscan];
  };

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # For swaylock
  security.pam.services.swaylock = {};

  hardware = {
    opengl.enable = true;
    opengl.driSupport = true;
    opengl.driSupport32Bit = true;
    opengl.extraPackages = with pkgs; [
      vaapiVdpau
      libvdpau-va-gl
    ];
  };

  # Bluetooth
  hardware.bluetooth = {
    # package = pkgs.bluez.overrideAttrs (oldAttrs: {
    #   patches =
    #     oldAttrs.patches
    #     ++ [
    #       (pkgs.fetchpatch {
    #         url = "https://github.com/BluezTestBot/bluez/commit/1608878095ba93f9e2385dde2cfdb1488ae6ebea.patch";
    #         sha256 = "sha256-UUmYMHnxYrw663nEEC2mv3zj5e0omkLNejmmPUtgS3c=";
    #       })
    #     ];
    # });
    package = pkgs.bluez;
    enable = true;
    settings = {
      General = {
        JustWorksRepairing = "always";
        FastConnectable = true;
        Class = "0x000100";
      };
      GATT = {
        ReconnectIntervals = "1,1,2,3,5,8,13,21,34,55";
        AutoEnable = true;
      };
    };
    input = {
      General = {
        UserspaceHID = true;
      };
    };
  };
  services.blueman.enable = true;

  # Drawing Tablets
  hardware.opentabletdriver.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.mihranmashhud = {
    isNormalUser = true;
    description = "Mihran Mashhud";
    extraGroups = [
      "networkmanager"
      "wheel"
      "scanner"
      "lp"
    ];
    shell = pkgs.zsh;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    home-manager

    # Pull files
    git
    wget
    curl

    # Qt
    libsForQt5.qt5.qtquickcontrols2
    libsForQt5.qt5.qtgraphicaleffects

    # Lutris
    lutris
    wineWowPackages.stable
    wineWowPackages.waylandFull
    winetricks

    protontricks
  ];

  environment.variables = {
    EDITOR = "nvim";
    NIXOS_OZONE_WL = "1";
  };

  environment.pathsToLink = [
    "/share/zsh"
  ];

  environment.shells = with pkgs; [
    zsh
  ];

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      roboto-slab
      inter
      (nerdfonts.override {
        fonts = [
          "CascadiaCode"
          "FiraCode"
          "Hasklig"
          "Iosevka"
          "VictorMono"
        ];
      })
    ];
    fontconfig = {
      defaultFonts = {
        sansSerif = ["Inter"];
        serif = ["Roboto Slab"];
        monospace = ["CaskaydiaCove Nerd Font"];
      };
    };
  };

  programs = {
    zsh.enable = true;
    hyprland.enable = true;
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      extraCompatPackages = [
        inputs.nix-gaming.packages.${pkgs.system}.proton-ge
      ];
    };
    nm-applet.enable = true;
    kdeconnect.enable = true;
    java.enable = true;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;
  services.udisks2.enable = true;

  services.udev.packages = with pkgs; [
    qmk-udev-rules
    vial-udev-rules
  ];

  services.postgresql = {
    enable = true;
    ensureDatabases = [
      "mydatabase"
      "i3-institute-local"
    ];
    authentication = pkgs.lib.mkOverride 10 ''
      #type database  DBuser  auth-method
      local all       all     trust
      #type database DBuser origin-address auth-method
      # ipv4
      host  all      all     127.0.0.1/32   trust
    '';
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
  networking.firewall.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

  nix.settings = {
    experimental-features = ["nix-command" "flakes"];
    auto-optimise-store = true;
    substituters = [
      "https://nix-community.cachix.org"
      "https://cache.nixos.org/"
    ];
    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 1w";
  };
}
