{ stdenv, callPackage, fetchurl, modDirVersionArg ? null, ... } @ args:

with stdenv.lib;

with (import ./patch.nix);

let
  configfile = ./linux-5.5.config;

  version = "5.5-rc7";
  branch = "5.5";
  src = fetchurl {
    url = "https://git.kernel.org/torvalds/t/linux-${version}.tar.gz";
    sha256 = "10fjk4bw73x5xpb4q83ngni7slw489wdxhdwmyrkfqqy5chgm290";
  };
  # modDirVersion needs to be x.y.z, will always add .0
  modDirVersion = if (modDirVersionArg == null) then builtins.replaceStrings ["-"] [".0-"] version else modDirVersionArg;

  kernelPatches = [
    # rtc
    (librePatch "amlogic-0156-WIP-arm64-dts-meson-g12b-odroid-n2-add-battery-rtc-s")
    (forumPatch "text-offset")
  ] ++ (armbianPatches "meson64-dev");

in (callPackage ./generic.nix (args // {
    inherit src version modDirVersion configfile kernelPatches branch;
}))
