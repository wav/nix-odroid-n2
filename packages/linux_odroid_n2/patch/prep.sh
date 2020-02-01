#!/bin/sh

[[ ! -f prep.sh ]] && exit 1;

[[ ! -f default.nix ]] && exit 1;

prepare() {
	if [ -f ./cleanup.sh ]; then
		./cleanup.sh || return 1;
	fi
	for branch in $(ls -1 -d */); do
		branch=${branch%/}
		echo "[" > $branch.nix
		ls -1 "$branch" | sed -ne 's/^\(.*\).patch$/"\1"/p' >> $branch.nix
		echo "]" >> $branch.nix
	done
}

for group in $(ls -1 -d */); do
	(
		cd $group; 
		rm *.nix 2>/dev/null; 
		prepare;
	)
done
