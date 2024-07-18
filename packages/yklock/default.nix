{
  writeTextFile,
  writeShellApplication,
  pamtester,
  procps,
  hyprlock,
  libnotify,
}:
writeShellApplication {
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
}
