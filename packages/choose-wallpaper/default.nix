{
  writeShellApplication,
  swww,
  imv,
  feh,
}: let
  bg-choice-file = "$HOME/.cache/background-img";
  bgs-dir = "$HOME/Pictures/Backgrounds";
in
  writeShellApplication {
    name = "choose-wallpaper";
    runtimeInputs = [swww imv feh];
    text =
      /*
      bash
      */
      ''
        CHOICE="${bg-choice-file}"

        cd "${bgs-dir}"

        pic=$(imv .)

        ln -sf "$pic" "$CHOICE"

        if [[ "$XDG_SESSION_TYPE" == "wayland" ]]; then
          swww img "$pic" --transition-type center
        else
          feh --no-fehbg --bg-fill "$pic"
        fi
      '';
  }
