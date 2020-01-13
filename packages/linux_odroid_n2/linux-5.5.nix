{ stdenv, callPackage, fetchurl, modDirVersionArg ? null, ... } @ args:

with stdenv.lib;

with (import ./patch.nix);

let
  configfile = ./linux-5.5.config;

  version = "5.5-rc5";
  branch = "5.5";
  src = fetchurl {
    url = "https://git.kernel.org/torvalds/t/linux-${version}.tar.gz";
    sha256 = "0h5ks0c0pdl0awiysqja6ky5ykhjcdicc01wi01wzhjklq9j0lmq";
  };
  # modDirVersion needs to be x.y.z, will always add .0
  modDirVersion = if (modDirVersionArg == null) then builtins.replaceStrings ["-"] [".0-"] version else modDirVersionArg;

  kernelPatches = [
    # rtc
    (librePatch "amlogic-0156-WIP-arm64-dts-meson-g12b-odroid-n2-add-battery-rtc-s")

    (forumPatch "text-offset")
    (forumPatch "park-5.4")    

    (armbianPatch "board-media-rc-drivers-should-produce-alternate-pulse-and-space-timing-events")
    (armbianPatch "general-add-configfs-overlay")
    (armbianPatch "general-add-overlay-compilation-support")
    (armbianPatch "general-dwc2-partial-powerdown-fix")
    (armbianPatch "general-meson64-i2cX-missing-pins")
    (armbianPatch "general-meson64-overlays")
    (armbianPatch "meson64_fclk_div3")
    (armbianPatch "meson64_remove_spidev_warning")
    (armbianPatch "x-0147-si2168-fix-cmd-timeout")
  ];

in (callPackage ./generic.nix (args // {
    inherit src version modDirVersion configfile kernelPatches branch;
}))
