{ stdenv, callPackage, fetchurl, modDirVersionArg ? null, ... } @ args:

with stdenv.lib;

with (import ./patch/default.nix stdenv.lib);

let
  configfile = ./linux-5.4.config;

  version = "5.4.27";
  branch = versions.majorMinor version;
  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v5.x/linux-${version}.tar.xz";
    sha256 = "0szc1p9y6z8gs2f1nj45nrz52sxcabg2xh7zqlljazv45lvcvf8r";
  };
  # modDirVersion needs to be x.y.z, will always add .0
  modDirVersion = if (modDirVersionArg == null) then concatStringsSep "." (take 3 (splitVersion "${version}.0")) else modDirVersionArg;

  kernelPatches = (patchsets [
    "armbian/5.4"
    "forum/5.4"
    "libre/5.4"
  ]);

in (callPackage ./generic.nix (args // {
  inherit src version modDirVersion configfile kernelPatches branch;
  NIX_CFLAGS_COMPILE = toString [
    "-mcpu=native"
  ];
}))
