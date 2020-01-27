{
  armbianPatches = branch: 
    let
      list = import (./armbian_patches + "/${branch}.nix");
    in
      map (name: { 
	inherit name; 
	patch = (./armbian_patches + "/${branch}/${name}.patch"); 
      }) list;
  forumPatch = name: { patch = (./forum_patches + "/${name}.patch"); };
  librePatch = name: { inherit name; patch = (./libre_patches + "/${name}.patch"); };
}
