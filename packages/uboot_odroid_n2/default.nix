{ buildUBoot, ethaddr ? null, stdenv, fetchFromGitLab, ... } @ args:

let
  extra = ./extra;
  ethaddr_ = if (ethaddr == null) then "" else ethaddr;
in
buildUBoot {
  version = "v2020.04.20";
  src = fetchFromGitLab {
    domain = "gitlab.denx.de";
    owner = "u-boot/custodians";
    repo = "u-boot-amlogic";
    rev = "b608865b88f0a5172c8ddcb48fd0f513fa01e114";
    sha256 = "0kyr59f6xka0ji37dv4k1kjys3sibgrppqx8g2rlc78bz8nyqhya";
  };
  defconfig = "odroid-n2_defconfig";
  extraMeta.platforms = [ "aarch64-linux" ];
  filesToInstall = [ "u-boot.bin" ];
  # TODO workout what the /tmp error is
  preBuild = ''
  cp -Rf ${extra} extra
  sedw() {
        echo patching $2 ...
	cp $2 /tmp/.sedw
        sed -ibk "$1" /tmp/.sedw
        chmod +w $2
        cat /tmp/.sedw > $2
        rm /tmp/.sedw || true
  }
  if [[ "${ethaddr_}" != "" ]]; then
    sedw 's|"distro_bootcmd="\(.*\)\\|"distro_bootcmd=env exists ethaddr \|\| setenv ethaddr ${ethaddr_}; " \\\n         \1 \\|' include/config_distro_bootcmd.h
  fi
  for path in ./extra/pack.sh ./extra/fip/blx_fix.sh; do
    sedw 's|#!/usr/bin/env bash|#!${args.bash}/bin/bash|' $path
  done
  '';
  postBuild = ''
    chmod -Rf ug+w extra
    ./extra/pack.sh
  '';
  installPhase = ''
    mkdir -p $out
    cp extra/fip/u-boot.bin $out
  '';
}
