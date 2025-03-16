{ lib, ... }:
let
  conv = import ./color_convert.nix { inherit lib; };
in 
{
  # Given a hex palette
  # (which is a attrset names being the color names, values being hex colors)
  # Return an attrset for hex, rbg, and rgbStrings.

  # jlib.fullPalette { black = "11111B"; blue = "89b4fa"; } =>
  # {
  #   hex = { black = "11111B"; blue = "89b4fa"; };
  #   rbg = { black = [ 17 17 27 ]; blue = [ 137 180 250 ]; };
  #   rbgComma = { black = "17,17,27"; blue = "137,180,250"; };
  # }
  fullPalette = palette: {
    hex = palette;
    rgb = lib.mapAttrs (_: color: conv.hexToRGB color) palette;  
    rgbComma = lib.mapAttrs (_: color: conv.hexToRGBString "," color) palette;  
  };
}
