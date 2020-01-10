uboot:
	nix-build release.nix -A uboot

sd-image:
	nix-build release.nix -A sdImage
