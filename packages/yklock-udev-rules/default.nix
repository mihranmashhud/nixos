{
  systemd,
  stdenv,
  writeTextFile,
}: let
  udevRules = writeTextFile {
    name = "yklock-udev-rules";
    text = ''
      ACTION=="remove",\
      ENV{ID_VENDOR}=="Yubico",\
      ENV{ID_VENDOR_ID}=="1050",\
      ENV{ID_MODEL_ID}=="0010|0111|0112|0113|0114|0115|0116|0401|0402|0403|0404|0405|0406|0407|0410",\
      RUN+="${systemd}/bin/loginctl lock-sessions"
    '';
  };
in
  stdenv.mkDerivation rec {
    pname = "yklock-udev-rules";
    name = pname;
    dontUnpack = true;
    installPhase = ''
      install -Dm 644 "${udevRules}" "$out/lib/udev/rules.d/99-yklock.rules"
    '';
  }
