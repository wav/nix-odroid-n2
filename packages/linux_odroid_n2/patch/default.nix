{ ... } @ lib:

let
  patchset = branch:
    let
      list = import (./. + "/${branch}.nix");
    in
      map (name: { 
        inherit name; 
        patch = (./. + "/${branch}/${name}.patch"); 
      }) list;
  concat = lib.foldr (a: b: a ++ b) [];
in
{
  patchsets = branches:
    concat (map patchset branches);
}
