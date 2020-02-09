
{ stdenv, buildPackages, fetchFromGitHub, perl, buildLinux, libelf, utillinux, ... } @ args:

buildLinux (args // rec {
  version = "s922_9.0.0_64_20200130";

  # modDirVersion needs to be x.y.z.
  modDirVersion = "4.9.210";

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

} // (args.argsOverride or {}))
