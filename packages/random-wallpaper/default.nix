{
  writeShellApplication,
  swww,
  feh,
}: let
  bg-choice-file = "$HOME/.cache/background-img";
  bgs-dir = "$HOME/Pictures/Backgrounds";
in
  writeShellApplication {
    name = "random-wallpaper";
    runtimeInputs = [swww feh];
    text =
      /*
      bash
      */
      ''
        CHOICE="${bg-choice-file}"

        cd "${bgs-dir}"

        pic=$(find "$PWD" -type f | grep -v "$(readlink "$CHOICE")" | shuf -n1)

        if [ -z "$pic" ]; then
          pic=$(find "$PWD" | shuf -n1)
        fi

        ln -sf "$pic" "$CHOICE"

        if [[ "$XDG_SESSION_TYPE" == "wayland" ]]; then
          swww img "$pic" --transition-type center
        else
          feh --no-fehbg --bg-fill "$pic"
        fi
      '';
  }
