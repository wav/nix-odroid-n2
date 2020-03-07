kernel:
	nix-build release.nix -A kernel_5_4

uboot:
	nix-build release.nix -A uboot

sd-image:
	nix-build release.nix -A sdImage
