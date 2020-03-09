
{ stdenv, buildPackages, fetchFromGitHub, perl, buildLinux, libelf, overrideCC, gcc6, utillinux, ... } @ args:

with stdenv.lib;

let
  configuredKernel = buildLinux (args // rec {
    version = "s922_9.0.0_64_20200130";
  
    # modDirVersion needs to be x.y.z.
    modDirVersion = "4.9.113";
  
    # branchVersion needs to be x.y.
    extraMeta.branch = "4.9";
  
    src = fetchFromGitHub {
      owner = "hardkernel";
      repo = "linux";
      rev = version;
      sha256 = "02xppxqbr4w4jyh4sxalmyl2mzslymdrdzqpmy71qkijb961xxks";
    };
  
    defconfig = "odroidn2_defconfig";
  
    kernelPatches = [];

    extraConfig = ''
      EXT4_ENCRYPTION y
    '';

  } // (args.argsOverride or {}));
in
overrideDerivation configuredKernel (old: {
  NIX_CFLAGS_COMPILE = toString [
    "-mcpu=native"
    "-Wno-error=attribute-alias"
    "-Wno-error=missing-attributes"
    "-Wno-error=stringop-truncation"
    "-Wno-error=address-of-packed-member"
    "-Wno-error=array-bounds"
  ];
  # stedenv = overrideCC stdenv gcc6;
})
