{
  armbianPatch = name: { inherit name; patch = (./armbian_patches + "/${name}.patch"); };
  forumPatch = name: { inherit name; patch = (./forum_patches + "/${name}.patch"); };
  librePatch = name: { inherit name; patch = (./libre_patches + "/${name}.patch"); };
}
