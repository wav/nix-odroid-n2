{ stdenv, callPackage, fetchurl, modDirVersionArg ? null, ... } @ args:

with stdenv.lib;

with (import ./patch/default.nix stdenv.lib);

let
  configfile = ./linux-5.5.config;

  version = "5.6-rc1";
  branch = "5.6";
  src = fetchurl {
    url = "https://git.kernel.org/torvalds/t/linux-${version}.tar.gz";
    sha256 = "10fjk4bw73x5xpb4q83ngni7slw489wdxhdwmyrkfqqy5chgm29d";
  };
  # modDirVersion needs to be x.y.z, will always add .0
  modDirVersion = if (modDirVersionArg == null) then builtins.replaceStrings ["-"] [".0-"] version else modDirVersionArg;

  kernelPatches = (patchsets [
    "armbian/5.5"
    "libre/5.5"
    "khadas/5.4"
  ]);

in (callPackage ./generic.nix (args // {
    inherit src version modDirVersion configfile kernelPatches branch;
}))
