{
  lib,
  pkgs,
  inputs,
  namespace, # The namespace used for your flake, defaulting to "internal" if not set.
  system, # The system architecture for this host (eg. `x86_64-linux`).
  target, # The Snowfall Lib target for this system (eg. `x86_64-iso`).
  format, # A normalized name for the system target (eg. `iso`).
  virtual, # A boolean to determine whether this system is a virtual target using nixos-generators.
  systems, # An attribute map of your defined hosts.
  config,
  ...
}:
with lib;
with lib.${namespace}; let
  cfg = config.${namespace}.desktop.dms;
in {
  options.${namespace}.desktop.dms = with types; {
    enable = mkEnableOption "DankMaterialShell";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      kdePackages.qt6ct
    ];
    qt = {
      enable = true;
      style.name = "kvantum";
      platformTheme.name = "qt6ct";
    };
    programs.dankMaterialShell = {
      enable = true;
      enableDynamicTheming = false;
      default.settings = let
        isDesktop = config.${namespace}.desktop.hyprland.type == "desktop";
        themes = config.${namespace}.themes;
      in {
        matugenScheme = "scheme-tonal-spot";
        runUserMatugenTemplates = false;
        matugenTargetMonitor = "";
        dankBarTransparency = 0;
        dankBarWidgetTransparency = 1;
        popupTransparency = 1;
        dockTransparency = 1;
        use24HourClock = false;
        showSeconds = false;
        useFahrenheit = false;
        useAutoLocation = false;
        weatherEnabled = true;
        showLauncherButton = true;
        showWorkspaceSwitcher = true;
        showFocusedWindow = true;
        showWeather = true;
        showMusic = true;
        showClipboard = true;
        showCpuUsage = true;
        showMemUsage = true;
        showCpuTemp = true;
        showGpuTemp = true;
        selectedGpuIndex = 0;
        showSystemTray = true;
        showClock = true;
        showNotificationButton = true;
        showBattery = true;
        showControlCenterButton = true;
        controlCenterShowNetworkIcon = true;
        controlCenterShowBluetoothIcon = true;
        controlCenterShowAudioIcon = true;
        controlCenterWidgets =
          (
            if isDesktop
            then [
              {
                id = "volumeSlider";
                enabled = true;
                width = 100;
              }
            ]
            else [
              {
                id = "volumeSlider";
                enabled = true;
                width = 50;
              }
              {
                id = "brightnessSlider";
                enabled = true;
                width = 50;
              }
            ]
          )
          ++ [
            {
              id = "wifi";
              enabled = true;
              width = 50;
            }
            {
              id = "bluetooth";
              enabled = true;
              width = 50;
            }
            {
              id = "audioOutput";
              enabled = true;
              width = 50;
            }
            {
              id = "audioInput";
              enabled = true;
              width = 50;
            }
            {
              id = "nightMode";
              enabled = true;
              width = 50;
            }
            {
              id = "doNotDisturb";
              enabled = true;
              width = 50;
            }
          ];
        showWorkspaceIndex = true;
        workspaceScrolling = true;
        showWorkspacePadding = false;
        showWorkspaceApps = false;
        maxWorkspaceIcons = 3;
        workspacesPerMonitor = true;
        waveProgressEnabled = true;
        clockCompactMode = false;
        focusedWindowCompactMode = false;
        runningAppsCompactMode = true;
        keyboardLayoutNameCompactMode = false;
        runningAppsCurrentWorkspace = false;
        runningAppsGroupByApp = false;
        clockDateFormat = "MMM d";
        mediaSize = 0;
        dankBarLeftWidgets = [
          {
            id = "workspaceSwitcher";
            enabled = true;
          }
          {
            id = "focusedWindow";
            enabled = true;
          }
        ];
        dankBarCenterWidgets = [
          {
            id = "music";
            enabled = true;
          }
          {
            id = "clock";
            enabled = true;
          }
          {
            id = "weather";
            enabled = true;
          }
        ];
        dankBarRightWidgets =
          [
            {
              id = "systemTray";
              enabled = true;
            }
            {
              id = "notificationButton";
              enabled = true;
            }
            {
              id = "network_speed_monitor";
              enabled = true;
            }
          ]
          ++ (
            if isDesktop
            then []
            else [
              {
                id = "battery";
                enabled = true;
              }
            ]
          )
          ++ [
            {
              id = "controlCenterButton";
              enabled = true;
            }
          ];
        fontFamily = "JetBrains Mono";
        monoFontFamily = "Fira Code";
        fontWeight = 400;
        fontScale = 1;
        dankBarFontScale = 0.95;
        soundsEnabled = true;
        useSystemSoundTheme = false;
        soundNewNotification = true;
        soundVolumeChanged = true;
        soundPluggedIn = true;
        gtkThemingEnabled = false;
        qtThemingEnabled = false;
        syncModeWithPortal = true;
        showDock = false;
        dockAutoHide = false;
        dockGroupByApp = true;
        dockOpenOnOverview = false;
        dockPosition = 1;
        dockSpacing = 4;
        dockBottomGap = 0;
        dockIconSize = 40;
        dockIndicatorStyle = "circle";
        cornerRadius = 8;
        notificationOverlayEnabled = true;
        dankBarAutoHide = false;
        dankBarOpenOnOverview = false;
        dankBarVisible = true;
        dankBarSpacing = 0;
        dankBarBottomGap = 0;
        dankBarInnerPadding = 5;
        dankBarSquareCorners = false;
        dankBarNoBackground = false;
        dankBarGothCornersEnabled = false;
        dankBarBorderEnabled = false;
        dankBarBorderColor = "surfaceText";
        dankBarBorderOpacity = 1;
        dankBarBorderThickness = 1;
        popupGapsAuto = true;
        popupGapsManual = 4;
        dankBarPosition = 0;
        lockScreenShowPowerActions = true;
        enableFprint = false;
        maxFprintTries = 3;
        hideBrightnessSlider = false;
        widgetBackgroundColor = "s";
        surfaceBase = "s";
        wallpaperFillMode = "Fill";
        blurredWallpaperLayer = false;
        blurWallpaperOnOverview = false;
        notificationTimeoutLow = 5000;
        notificationTimeoutNormal = 5000;
        notificationTimeoutCritical = 0;
        notificationPopupPosition = 0;
        osdAlwaysShowValue = true;
        powerActionConfirm = true;
        customPowerActionLock = "";
        customPowerActionLogout = "";
        customPowerActionSuspend = "";
        customPowerActionHibernate = "";
        customPowerActionReboot = "";
        customPowerActionPowerOff = "";
        updaterUseCustomCommand = false;
        updaterCustomCommand = "";
        updaterTerminalAdditionalParams = "";
        showOnLastDisplay = {
          dock = true;
          toast = true;
        };
        animationSpeed = 1;
        customAnimationDuration = 500;
        acMonitorTimeout = 0;
        acLockTimeout = 0;
        acSuspendTimeout = 0;
        acHibernateTimeout = 0;
        batteryMonitorTimeout = 0;
        batteryLockTimeout = 0;
        batterySuspendTimeout = 0;
        batteryHibernateTimeout = 0;
        lockBeforeSuspend = true;
        loginctlLockIntegration = true;
      };
    };
    services.mako.enable = mkForce false;
  };
}
