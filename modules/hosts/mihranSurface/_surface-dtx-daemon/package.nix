{
  rustPlatform,
  pkg-config,
  dbus,
}:
rustPlatform.buildRustPackage rec {
  name = "surface-dtx-daemon-${version}";
  version = "0.3.12-1";
  src = builtins.fetchurl {
    url = "https://github.com/linux-surface/surface-dtx-daemon/archive/v${version}.tar.gz";
    sha256 = "0jyjb9bmz8rqk9b65ami24hdi8jlk6qxlwvvprympaifzb9p80z5";
  };

  nativeBuildInputs = [pkg-config];
  buildInputs = [dbus];

  cargoHash = "sha256-QuA2D6FGg8y1wBRRmIFS9urp96gHa+vVYssLXMaTya0=";

  postInstall = ''
    mkdir -p $out/etc/udev/rules.d
    cp etc/udev/40-surface_dtx.rules $out/etc/udev/rules.d/

    mkdir -p $out/etc/systemd/system
    cp etc/systemd/*.service $out/etc/systemd/system/

    mkdir -p $out/etc/dbus-1/system.d
    cp etc/dbus/org.surface.dtx.conf $out/etc/dbus-1/system.d/

    mkdir -p $out/etc/dtx
    cp etc/dtx/*.conf $out/etc/dtx/
  '';
}
