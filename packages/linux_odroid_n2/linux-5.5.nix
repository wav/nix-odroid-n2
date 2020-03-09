{ stdenv, callPackage, fetchurl, modDirVersionArg ? null, ... } @ args:

with stdenv.lib;

with (import ./patch/default.nix stdenv.lib);

let
  configfile = ./linux-5.4.config;

  version = "5.5.8";
  branch = versions.majorMinor version;
  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v5.x/linux-${version}.tar.xz";
    sha256 = "01pw0gfafbsds6vq26qynffwvqm4khs953k1b6rrz8wris9zddp5";
  };
  # modDirVersion needs to be x.y.z, will always add .0
  modDirVersion = if (modDirVersionArg == null) then concatStringsSep "." (take 3 (splitVersion "${version}.0")) else modDirVersionArg;

  kernelPatches = (patchsets [
    "armbian/5.5"
  ]);

in (callPackage ./generic.nix (args // {
  inherit src version modDirVersion configfile kernelPatches branch;
  NIX_CFLAGS_COMPILE = toString [
    "-mcpu=native"
  ];
}))
