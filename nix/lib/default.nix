{ lib, ... }:
{
  colorConvert = import ./color_convert.nix { inherit lib; };
}
