{ stdenv, callPackage, buildPackages, fetchurl, buildLinux, ubootTools, modDirVersionArg ? null, ... } @ args:

with stdenv.lib;

with (import ./patch/default.nix stdenv.lib);

let
  kernelPatches = (patchsets [
    "armbian/5.6"
    "libre/5.4"
  ]);

  NIX_CFLAGS_COMPILE = toString [
    "-mcpu=native"
  ];

  kernel = buildLinux (args // rec {
    inherit kernelPatches NIX_CFLAGS_COMPILE;

    version = "5.6.3";

    # modDirVersion needs to be x.y.z, will automatically add .0 if needed
    modDirVersion = if (modDirVersionArg == null) then concatStringsSep "." (take 3 (splitVersion "${version}.0")) else modDirVersionArg;

    # branchVersion needs to be x.y
    extraMeta.branch = versions.majorMinor version;

    src = fetchurl {
      url = "mirror://kernel/linux/kernel/v5.x/linux-${version}.tar.xz";
      sha256 = "1ajh1iw3bplm6ckcycg45wfmmqkvfiqmh6i3m1895dfapfd6h4qx";
    };
  } // (args.argsOverride or {}));

in callPackage ./configure.nix {

  inherit stdenv ubootTools kernel;

  configfile = ./linux-5.4.config;
}