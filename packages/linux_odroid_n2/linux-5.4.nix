{ stdenv, callPackage, fetchurl, modDirVersionArg ? null, ... } @ args:

with stdenv.lib;

with (import ./patch.nix);

let
  configfile = ./linux-5.4.config;

  version = "5.4.8";
  branch = versions.majorMinor version;
  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v5.x/linux-${version}.tar.xz";
    sha256 = "1j4916izy2nrzq7g6m5m365r60hhhx9rqcanjlaxv5x3vsy63ggx";
  };
  # modDirVersion needs to be x.y.z, will always add .0
  modDirVersion = if (modDirVersionArg == null) then concatStringsSep "." (take 3 (splitVersion "${version}.0")) else modDirVersionArg;

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
