{ lib, ... }:
let
  # Import all files in this dir
  # Mush all the other files attrs into a top level attrset
  jlib = with builtins; foldl' (prev: new: lib.recursiveUpdate prev (import (./. + "/${new}") { inherit lib; })) {} (filter (x: x != "default.nix") (attrNames (readDir ./.)));
in
{
  _module.args = { inherit jlib; };
}
