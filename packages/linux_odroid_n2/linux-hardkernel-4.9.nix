
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
      AMLOGIC_MEDIA_VIDEO n
      AMLOGIC_MEDIA_ENABLE n
      AMLOGIC_MEDIA_COMMON n
      AMLOGIC_MEDIA_DRIVERS n
      AMLOGIC_DVB n
      MEDIA_SUPPORT n
      WLAN n
      BT n
      MEDIA_TUNER n
      DVB_CORE n
      DVB_NET n
      MEDIA_CAMERA_SUPPORT n
      MEDIA_DIGITAL_TV_SUPPORT n
      SND n
      SOUND n
    '';

  } // (args.argsOverride or {}));
in
overrideDerivation configuredKernel (old: {
  # collect flags using `cat nohup.out | grep -oE "\-W[^]]*" | sort | uniq`
  NIX_CFLAGS_COMPILE = toString [
    "-march=armv8-a+crc+crypto"
    "-mcpu=cortex-a73.cortex-a53+crc+crypto"
    # "-mcpu=native" # crc missing
    "-mtune=cortex-a73.cortex-a53"
    "-Wno-error=attribute-alias"
    "-Wno-error=missing-attributes"
    "-Wno-error=stringop-truncation"
    "-Wno-error=address-of-packed-member"
    "-Wno-error=array-bounds"
    "-Wno-error=sizeof-pointer-memaccess"
    "-Wno-error=packed-not-aligned"
    "-Wno-error=sizeof-pointer-memaccess"
    "-Wno-error=larger-than=28792"
    "-Wno-error=maybe-uninitialized"
    "-Wno-error=stringop-overflow"
    "-Wno-error=incompatible-pointer-types"
    #"-Wno-error=implicit-function-declaration"
    "-Wno-implicit-function-declaration"
  ];
  # stdenv = overrideCC stdenv gcc6;
})
