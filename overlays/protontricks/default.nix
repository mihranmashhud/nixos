# Snowfall Lib provides access to additional information via a primary argument of
# your overlay.
{
  # Channels are named after NixPkgs instances in your flake inputs. For example,
  # with the input `nixpkgs` there will be a channel available at `channels.nixpkgs`.
  # These channels are system-specific instances of NixPkgs that can be used to quickly
  # pull packages into your overlay.
  channels,
  # Inputs from your flake.
  inputs,
  ...
}: (final: prev: {
  vdf-patch = prev.python312Packages.vdf.overrideAttrs (oldAttrs: rec {
    src = inputs.vdf-patch;
  });
  protontricks-beta = prev.protontricks.overrideAttrs (oldAttrs: rec {
    src = inputs.protontricks;
    propagatedBuildInputs = [
      prev.python312Packages.setuptools # implicit dependency, used to find data/icon_placeholder.png
      final.vdf-patch
      prev.python312Packages.pillow
    ];
  });
})
