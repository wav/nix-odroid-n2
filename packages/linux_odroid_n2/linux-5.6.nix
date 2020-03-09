{ stdenv, callPackage, fetchurl, modDirVersionArg ? null, ... } @ args:

with stdenv.lib;

with (import ./patch/default.nix stdenv.lib);

let
  configfile = ./linux-5.4.config;

  version = "5.6-rc5";
  branch = "5.6";
  src = fetchurl {
    url = "https://git.kernel.org/torvalds/t/linux-${version}.tar.gz";
    sha256 = "0ys4wdv1rf9vshras1n6syy2pgg8kv50f27nprfzhrllni044whr";
  };
  # modDirVersion needs to be x.y.z, will always add .0
  modDirVersion = if (modDirVersionArg == null) then builtins.replaceStrings ["-"] [".0-"] version else modDirVersionArg;

  kernelPatches = (patchsets [
    "armbian/5.6"
    "libre/5.4"
  ]);

in (callPackage ./generic.nix (args // {
  inherit src version modDirVersion configfile kernelPatches branch;
  NIX_CFLAGS_COMPILE = toString [
    "-mcpu=native"
  ];
}))
