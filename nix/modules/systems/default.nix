{ ... }:
{
  # Import everything in this dir other than default.nix
  imports = (map (x: ./. + "/${x}")
    (with builtins; filter (x: x != "default.nix")
      (attrNames (readDir ./.)))) ++ [ ../../lib ];  
}
