{ ... }:
{
  # Import everything in this dir other than the top level default.nix
  imports = (map (x: ./. + "/${x}")
    (with builtins; filter (x: x != "default.nix")
      (attrNames (readDir ./.))));  
}
