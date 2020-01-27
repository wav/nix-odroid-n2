#!/bin/sh

meson64-*/general-kernel-odroidn2-current.patch 2> /dev/null

for branch in $(ls -1 -d */); do
	branch=${branch%/}
	echo prep $branch.nix
	echo "[" > $branch.nix
	ls -1 meson64-current | sed -e 's/^\(.*\).patch$/"\1"/' >> $branch.nix
	echo "]" >> $branch.nix
done
