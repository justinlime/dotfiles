{ ... }:
{
  # Import everything in this dir other than top level default.nix
  imports = (map (x: ./. + "/${x}")
    (with builtins; filter (x: x != "default.nix")
      (attrNames (readDir ./.)))) ++ [ ../../lib ];  
}
