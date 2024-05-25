{pkgs}:
with pkgs; let
  bg-choice-file = "$HOME/.cache/background-img";
  bgs-dir = "$HOME/Pictures/Backgrounds";
  system-sounds = "${pkgs.deepin.deepin-sound-theme}/share/sounds/deepin/stereo";
  nix-rebuild-log = "nixos-rebuild.log";
  nix-config-dir = "$HOME/nixos"; # Change to the location of your nixos config.
in rec {
  rebuild-nixos = writeShellApplication {
    name = "rebuild-nixos";
    runtimeInputs = [libnotify play-bell alejandra play-bell-error];
    text =
      /*
      bash
      */
      ''
        set -e

        pushd "${nix-config-dir}"

        # Format files
        alejandra .

        # Show changes
        git diff -U0 **/*.nix

        echo "NixOS Rebuilding..."

        # Rebuild, output simplified errors, log tracebacks
        sudo nixos-rebuild switch --flake . &> "${nix-rebuild-log}" || (cat "${nix-rebuild-log}" | grep --color error && (notify-send -e "NixOS rebuild failed" && play-sound dialog-error) && false)

        notify-send -e "NixOS rebuild completed!"
        play-bell

        popd > /dev/null
      '';
    checkPhase = "";
  };

  choose-wallpaper = writeShellApplication {
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
  };

  random-wallpaper = writeShellApplication {
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
  };

  start-replay-buffer = writeShellApplication {
    name = "start-replay-buffer";
    runtimeInputs = [obs-studio];
    text =
      /*
      bash
      */
      ''
        obs --startreplaybuffer --minimize-to-tray &
      '';
  };

  restart-laptop-waybar = writeShellApplication {
    name = "restart-laptop-waybar";
    runtimeInputs = [killall waybar];
    text =
      /*
      bash
      */
      ''
        killall waybar || true
        nohup waybar -c ~/.config/waybar/laptop-config.json > /dev/null
      '';
  };

  restart-desktop-waybar = writeShellApplication {
    name = "restart-desktop-waybar";
    runtimeInputs = [killall waybar];
    text =
      /*
      bash
      */
      ''
        killall waybar || true
        nohup waybar -c ~/.config/waybar/desktop-config.json > /dev/null
      '';
  };

  play-bell = writeShellApplication {
    name = "play-bell";
    runtimeInputs = [mpv];
    text =
      /*
      bash
      */
      ''
        mpv ${system-sounds}/message.wav > /dev/null
      '';
  };
  play-bell-error = writeShellApplication {
    name = "play-sound";
    runtimeInputs = [mpv];
    text =
      /*
      bash
      */
      ''
        mpv "${system-sounds}/$1.wav" > /dev/null
      '';
  };
}
