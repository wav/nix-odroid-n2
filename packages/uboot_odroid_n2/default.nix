{ buildUBoot, ethaddr ? null, stdenv, fetchFromGitLab, ... } @ args:

let
  extra = ./extra;
  ethaddr_ = if (ethaddr == null) then "" else ethaddr;
in
buildUBoot {
  version = "v2020.1";
  src = fetchFromGitLab {
    domain = "gitlab.denx.de";
    owner = "u-boot";
    repo = "u-boot";
    rev = "262d34363373c10a00279036c1561283c30495c2";
    sha256 = "0p6vl5skcc4sgmca1r9lxq0yff6pj0z19cil75s1xw7fjhkmjasg";
  };
  defconfig = "odroid-n2_defconfig";
  extraMeta.platforms = [ "aarch64-linux" ];
  filesToInstall = [ "extra/fip/u-boot.bin.sd.bin" ];
  patches = [];
  extraPatches = [ ./extra/reset-usb.patch ];
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
    sedw 's|\("distro_bootcmd=".*\)\\|"ethaddr=${ethaddr_}\\0" \\\n        \1|' include/config_distro_bootcmd.h
  fi
  for path in ./extra/pack.sh ./extra/fip/blx_fix.sh; do
    sedw 's|#!/usr/bin/env bash|#!${args.bash}/bin/bash|' $path
  done
  '';
  postBuild = ''
    chmod -Rf ug+w extra
    ./extra/pack.sh
  '';
}
