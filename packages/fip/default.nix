{ stdenv, uboot, pkgs, ... } @ args:
let sources = import ../../nix/sources.nix; in
stdenv.mkDerivation {
    name = "Firmware-Image-Package";

    src = ./.;

    UBOOT="${uboot}/u-boot.bin";

    makeFlags = [ "PREFIX=$(out)" ];

    nativeBuildInputs = [ (import sources.meson64-tools { nixpkgs = pkgs.buildPackages; }).meson64-tools ];
}