{
  writeTextFile,
  writeShellApplication,
  pamtester,
  procps,
  hyprlock, libnotify,
}: let
  yklock-pkg = writeShellApplication {
    name = "yklock";
    runtimeInputs = [pamtester hyprlock procps libnotify];
    text =
      /*
      bash
      */
      ''
        if [[ "$1" == "lock" ]]; then
          notify-send "Yubikey unplugged." 
          pidof hyprlock || hyprlock
        elif [[ "$1" == "unlock" ]]; then
          if echo "" | pamtester login "$USER" authenticate; then
            # PAM login successful
            # kill locker
            notify-send "Yubikey plugged in." 
            pkill -SIGUSR1 hyprlock
          fi
        fi
        exit 0
      '';
  };
  yklock = "${yklock-pkg}/bin/yklock";
in writeTextFile {
  name = "yklock-udev-rules";
  text = ''
    ACTION=="remove", ENV{ID_VENDOR}=="Yubico", ENV{ID_VENDOR_ID}=="1050", ENV{ID_MODEL_ID}=="0010|0111|0112|0113|0114|0115|0116|0401|0402|0403|0404|0405|0406|0407|0410", RUN+="${yklock} lock"
    ACTION=="add", ENV{ID_VENDOR}=="Yubico", ENV{ID_VENDOR_ID}=="1050", ENV{ID_MODEL_ID}=="0010|0111|0112|0113|0114|0115|0116|0401|0402|0403|0404|0405|0406|0407|0410", RUN+="${yklock} unlock"
  '';
  destination = "/etc/udev/rules.d/99-yklock.rules";
}
