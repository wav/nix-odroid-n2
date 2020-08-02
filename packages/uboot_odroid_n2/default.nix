{ buildUBoot, stdenv, fetchFromGitLab, ... } @ args:

let
  extra = ./extra;
in
buildUBoot {
  version = "v2020.04.20";
  # See https://gitlab.denx.de/u-boot/custodians/u-boot-amlogic/-/commit/6de936b011fb02d1019a69aea0184cee4a578f59
  # that's the first commit that introduces reading the ethaddr from the efuse!
  src = fetchFromGitLab {
    domain = "gitlab.denx.de";
    owner = "u-boot/custodians";
    repo = "u-boot-amlogic";
    rev = "6de936b011fb02d1019a69aea0184cee4a578f59";
    sha256 = "19jkmnmvd6758j55bjvh0dimjw9j776y6m8y4xjngpypvfgzsclc";
  };
  defconfig = "odroid-n2_defconfig";
  extraMeta.platforms = [ "aarch64-linux" ];
  filesToInstall = [ "u-boot.bin" ".config" ];
  preBuild = ''
  cp -Rf ${extra} extra
  chmod -Rf ug+w extra
  patchShebangs ./extra/pack.sh
  patchShebangs ./extra/fip/blx_fix.sh
  '';
  postBuild = ''
    chmod -Rf ug+w extra
    ./extra/pack.sh
    cp extra/fip/u-boot.bin .
  '';
}
