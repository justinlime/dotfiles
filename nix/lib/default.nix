{ lib, ... }:
# Import all files in this dir
# Mush all the other files attrs into a top level attrset
let
  jlib = {};
in
  with builtins;
  (head (map (x: jlib // (import (./. + "/${x}") { inherit lib; }))
    (filter (x: x != "default.nix") (attrNames (readDir ./.)))))

