#!/bin/sh

meson64-*/general-kernel-odroidn2-current.patch 2> /dev/null

rm meson64-dev/0450-arm64-dts-fix-IR-receiver-beelinkA1.patch

for branch in $(ls -1 -d */); do
	branch=${branch%/}
	echo prep $branch.nix
	echo "[" > $branch.nix
	ls -1 "$branch" | sed -ne 's/^\(.*\).patch$/"\1"/p' >> $branch.nix
	echo "]" >> $branch.nix
done
