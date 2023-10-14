{ appimageTools
, fetchurl
, imagemagick
}: 
let
  desktopFile = fetchurl {
    url = "https://raw.githubusercontent.com/alvr-org/ALVR/v20.4.3/alvr/xtask/resources/alvr.desktop";
    hash = "sha256-DjU/RjJJOALzQNSQwaPgAgPsQgnqX5FDWBcd/PDCetU=";
  };
  dashboardIcon = fetchurl {
    url = "https://raw.githubusercontent.com/alvr-org/ALVR/v20.4.3/alvr/dashboard/resources/dashboard.ico";
    hash = "sha256-x1qqGUsTjMl7NnQJ8EKVGBZcKhq8F9WKBhS4Z7bVk5w=";
  };
in
appimageTools.wrapType2 {
  name = "alvr_dashboard";

  src = fetchurl {
    url = "https://github.com/alvr-org/ALVR/releases/download/v20.4.3/ALVR-x86_64.AppImage";
    hash = "sha256-q6f8HbP/gCpFi9Ai7WqN/MBJl1HUOIhKWZfLOYsDANk=";
  };

  extraPkgs = pkgs: with pkgs; [
    alsaLib
    ffmpeg-full
    vulkan-headers
    vulkan-validation-layers
    clang
    libunwind
    libxkbcommon
    iconv
    chromium
  ];
  extraInstallCommands = ''
    install -Dm644 ${desktopFile} -t "$out/share/applications"

    for res in 16x16 32x32 48x48 64x64 128x128 256x256; do
      mkdir -p "icons/hicolor/$res/apps/"
      ${imagemagick}/bin/convert ${dashboardIcon} -thumbnail "$res" -alpha on -background none -flatten "./icons/hicolor/$res/apps/alvr.png"
    done
    install -d $out/share/icons/hicolor/{16x16,32x32,48x48,64x64,128x128,256x256}/apps/
    cp -ar icons/* $out/share/icons/
  '';
} 
