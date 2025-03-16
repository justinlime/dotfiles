# Stolen from
# https://github.com/Misterio77/nix-colors/blob/b92df8f5eb1fa20d8e09810c03c9dc0d94ef2820/lib/core/conversions.nix

#### Usage ####

# Function: hexToDec
# Desciption: Converts hex to decimal
# Args: string 
# Example: hexToDec "11111B" => 1118491

# Function: hexToRGB
# Desciption: Converts hex to RGB as a list  
# Args: string 
# Example: hexToRGB "11111B" => [ 17 17 27 ]

# Function: hexToDec
# Desciption: Converts hex to RGB as a string
# Args: string string 
# Example: hexToRGBString "," "11111B" => "17,17,27"

{ lib, ... }:
let
  hexToDecMap = {
    "0" = 0;
    "1" = 1;
    "2" = 2;
    "3" = 3;
    "4" = 4;
    "5" = 5;
    "6" = 6;
    "7" = 7;
    "8" = 8;
    "9" = 9;
    "a" = 10;
    "b" = 11;
    "c" = 12;
    "d" = 13;
    "e" = 14;
    "f" = 15;
  };

  /* Base raised to the power of the exponent.

     Type: pow :: int or float -> int -> int

     Args:
       base: The base.
       exponent: The exponent.

     Example:
       pow 0 1000
       => 0
       pow 1000 0
       => 1
       pow 2 30
       => 1073741824
       pow 3 3
       => 27
       pow (-5) 3
       => -125
  */
  pow = base: exponent:
    let inherit (lib) mod;
    in if exponent > 1 then
      let
        x = pow base (exponent / 2);
        odd_exp = mod exponent 2 == 1;
      in
      x * x * (if odd_exp then base else 1)
    else if exponent == 1 then
      base
    else if exponent == 0 && base == 0 then
      throw "undefined"
    else if exponent == 0 then
      1
    else
      throw "undefined";

  /* Conversion from base 16 to base 10 with a exponent. Is of the form
     scalar * 16 ** exponent.

     Type: base16To10 :: int -> int -> int

     Args:
       exponent: The exponent for the base, 16.
       scalar: The value to multiple to the exponentiated base.

     Example:
       base16To10 0 11
       => 11
       base16To10 1 3
       => 48
       base16To10 2 7
       1792
       base16To10 3 14
       57344
  */
  base16To10 = exponent: scalar: scalar * pow 16 exponent;

  /* Converts a hexadecimal character to decimal.
     Only takes a string of length 1.

     Type: hexCharToDec :: string -> int

     Args:
       hex: A hexadecimal character.

     Example:
       hexCharToDec "5"
       => 5
       hexCharToDec "e"
       => 14
       hexCharToDec "A"
       => 10
  */
  hexCharToDec = hex:
    let
      inherit (lib) toLower;
      lowerHex = toLower hex;
    in
    if builtins.stringLength hex != 1 then
      throw "Function only accepts a single character."
    else if hexToDecMap ? ${lowerHex} then
      hexToDecMap."${lowerHex}"
    else
      throw "Character ${hex} is not a hexadecimal value.";
in
rec {
  /* Converts from hexadecimal to decimal.

     Type: hexToDec :: string -> int

     Args:
       hex: A hexadecimal string.

     Example:
       hexadecimal "12"
       => 18
       hexadecimal "FF"
       => 255
       hexadecimal "abcdef"
       => 11259375
  */
  hexToDec = hex:
    let
      inherit (lib) stringToCharacters reverseList imap0 foldl;
      decimals = builtins.map hexCharToDec (stringToCharacters hex);
      decimalsAscending = reverseList decimals;
      decimalsPowered = imap0 base16To10 decimalsAscending;
    in
    foldl builtins.add 0 decimalsPowered;

  /* Converts a 6 character hexadecimal string to RGB values.

     Type: hexToRGB :: string => [int]

     Args:
       hex: A hexadecimal string of length 6.

     Example:
       hexToRGB "012345"
       => [ 1 35 69 ]
       hexToRGB "abcdef"
       => [171 205 239 ]
       hexToRGB "000FFF"
       => [ 0 15 255 ]
  */
  hexToRGB = hex:
    let
      rgbStartIndex = [ 0 2 4 ];
      hexList = builtins.map (x: builtins.substring x 2 hex) rgbStartIndex;
      hexLength = builtins.stringLength hex;
    in
    if hexLength != 6 then
      throw ''
        Unsupported hex string length of ${builtins.toString hexLength}.
        Length must be exactly 6.
      ''
    else
      builtins.map hexToDec hexList;

  /* Converts a 6 character hexadecimal string to an RGB string seperated by a
     delimiter.

     Type: hexToRGBString :: string -> string

     Args:
       sep: The delimiter or seperator.
       hex: A hexadecimal string of length 6.
  */
  hexToRGBString = sep: hex:
    let
      inherit (builtins) map toString;
      inherit (lib) concatStringsSep;
      hexInRGB = hexToRGB hex;
      hexInRGBString = map toString hexInRGB;
    in
    concatStringsSep sep hexInRGBString;
}
