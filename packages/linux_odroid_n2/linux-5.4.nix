{ stdenv, callPackage, fetchurl, modDirVersionArg ? null, ... } @ args:

with stdenv.lib;

with (import ./patch.nix);

let
  configfile = ./linux-5.4.config;

  version = "5.4.15";
  branch = versions.majorMinor version;
  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v5.x/linux-${version}.tar.xz";
    sha256 = "1ccldlwj89qd22cl06706w7xzm8n69m6kg8ic0s5ns0ghlpj41v4";
  };
  # modDirVersion needs to be x.y.z, will always add .0
  modDirVersion = if (modDirVersionArg == null) then concatStringsSep "." (take 3 (splitVersion "${version}.0")) else modDirVersionArg;

  kernelPatches = [
    # rtc
    (librePatch "amlogic-0156-WIP-arm64-dts-meson-g12b-odroid-n2-add-battery-rtc-s")
    (forumPatch "text-offset")
  ] ++ (armbianPatches "meson64-current");

in (callPackage ./generic.nix (args // {
    inherit src version modDirVersion configfile kernelPatches branch;
}))
