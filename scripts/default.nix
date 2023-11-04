{ config, pkgs, ... }:
let
  bgChoiceFile = "/tmp/background-choice";
  bgsLocation = "$HOME/Pictures/Backgrounds";
in
{
  imports = [
    ./alvr-audio.nix
  ];
  home.packages = with pkgs; [
    (writeShellApplication {
      name = "wayland-lockscreen";
      runtimeInputs = [swaylock];
      text = /* bash */ ''
        CHOICE="${bgChoiceFile}"
        pic=$(cat $CHOICE)
        swaylock "$@" -i "$pic" -s fill
      '';
    })

    (writeShellApplication {
      name = "choose-wallpaper";
      runtimeInputs = [swww imv feh];
      text = /* bash */ ''
        CHOICE="${bgChoiceFile}"

        cd "${bgsLocation}"

        pic=$(imv .)

        echo "$pic" > $CHOICE

        if [[ "$XDG_SESSION_TYPE" == "wayland" ]]; then
          swww img "$pic" --transition-type center
        else
          feh --no-fehbg --bg-fill "$pic"
        fi
      '';
    })

    (writeShellApplication {
      name = "random-wallpaper";
      runtimeInputs = [swww feh];
      text = /* bash */ ''
        CHOICE="${bgChoiceFile}"

        cd "${bgsLocation}"

        pic=$(find "$PWD" -type f | grep -v "$(cat $CHOICE)" | shuf -n1)

        if [ -z "$pic" ]; then
          pic=$(find "$PWD" | shuf -n1)
        fi

        echo "$pic" > $CHOICE

        if [[ "$XDG_SESSION_TYPE" == "wayland" ]]; then
          swww img "$pic" --transition-type center
        else
          feh --no-fehbg --bg-fill "$pic"
        fi
      '';
    })

    (writeShellApplication {
      name = "start-replay-buffer";
      runtimeInputs = [obs-studio];
      text = /* bash */ ''
        obs --startreplaybuffer --minimize-to-tray &
      '';
    })

    (writeShellApplication {
      name = "restart-laptop-waybar";
      runtimeInputs = [killall waybar];
      text = /* bash */ ''
        killall waybar
        nohup waybar -c ~/.config/waybar/laptop-config.json > /dev/null
      '';
    })

    (writeShellApplication {
      name = "restart-desktop-waybar";
      runtimeInputs = [killall waybar];
      text = /* bash */ ''
        killall waybar
        nohup waybar -c ~/.config/waybar/laptop-config.json > /dev/null
      '';
    })
  ];
}
