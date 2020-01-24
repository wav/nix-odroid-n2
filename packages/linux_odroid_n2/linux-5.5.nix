{ stdenv, callPackage, fetchurl, modDirVersionArg ? null, ... } @ args:

with stdenv.lib;

with (import ./patch.nix);

let
  configfile = ./linux-5.5.config;

  version = "5.5-rc7";
  branch = "5.5";
  src = fetchurl {
    url = "https://git.kernel.org/torvalds/t/linux-${version}.tar.gz";
    sha256 = "10fjk4bw73x5xpb4q83ngni7slw489wdxhdwmyrkfqqy5chgm290";
  };
  # modDirVersion needs to be x.y.z, will always add .0
  modDirVersion = if (modDirVersionArg == null) then builtins.replaceStrings ["-"] [".0-"] version else modDirVersionArg;

  kernelPatches = [
    # rtc
    (librePatch "amlogic-0156-WIP-arm64-dts-meson-g12b-odroid-n2-add-battery-rtc-s")

    (forumPatch "text-offset")

    (armbianPatch "0102-WIP-drm-panfrost-add-support-for-custom-soft-reset-on-GXM")
    (armbianPatch "0302-arm64-dts-meson-set-dma-pool-to-896MB")
    (armbianPatch "0303-dt-bindings-media-amlogic-vdec-convert-to-yaml")
    (armbianPatch "0304-dt-bindings-media-amlogic-gx-vdec-add-bindings-for-G12A-family")
    (armbianPatch "0305-media-meson-vdec-add-g12a-platform")
    (armbianPatch "0306-arm64-dts-meson-g12-common-add-video-decoder-node")
    (armbianPatch "0307-dt-bindings-media-amlogic-gx-vdec-add-bindings-for-SM1-family")
    (armbianPatch "0308-media-meson-vdec-add-sm1-platform")
    (armbianPatch "0309-arm64-dts-meson-sm1-add-video-decoder-compatible")
    (armbianPatch "0311-media-meson-vdec-bring-up-to-compliance-v2")
    (armbianPatch "0312-media-meson-vdec-add-H.264-decoding-support-v2")
    (armbianPatch "0328-media-meson-vdec-align-stride-on-32-bytes")
    (armbianPatch "0329-media-meson-vdec-add-helpers-for-lossless-framebuffer-compression-buffers")
    (armbianPatch "0330-media-meson-vdec-add-common-HEVC-decoder-support")
    (armbianPatch "0331-media-meson-vdec-add-VP9-input-support")
    (armbianPatch "0332-media-meson-vdec-add-VP9-decoder-support")
    (armbianPatch "0336-media-meson-vdec-add-HEVC-decoding-support")
    (armbianPatch "0345-arm64-dts-meson-gx-add-audio-controller-nodes")
    (armbianPatch "0347-arm64-dts-meson-gx-add-sound-dai-cells-to-HDMI-node")
    (armbianPatch "0348-arm64-dts-meson-activate-hdmi-audio-HDMI-enabled-boa")
    (armbianPatch "0350-drm-dw-hdmi-call-hdmi_set_cts_n-after-clock-is-")
    (armbianPatch "0351-fix-chmap_idx")
    (armbianPatch "0360-arm64-dts-meson-tanix-tx3-add-thermal-zones")
    (armbianPatch "2001-drm-lima-devfreq-and-cooling-device-support")
    (armbianPatch "3001-arm64_dts_meson_g12a_add_internal_DAC")
    (armbianPatch "ARM-dts-meson-clock-updates")
    (armbianPatch "crypto-amlogic-fix-removal-of-module")
    (armbianPatch "drm-meson-Remove-unneeded-semicolon")
    (armbianPatch "general-kernel-odroidn2-current")
    (armbianPatch "linux-5.4-net-smsc95xx-allow-mac-address-as-param")
    (armbianPatch "media-meson-add-missing-allocation-failure-check-on-new_buf")
    (armbianPatch "parkmode_disable_ss_quirk_on_DWC3")
    (armbianPatch "update_entries_for_disabling_SS_instances_in_park_mode")
    (armbianPatch "usb_dwc3_Add_support_for_disabling_SS_instances_in_park_mode")
    (armbianPatch "v2-clk-meson-pll-Fix-by-0-division-in-__pll_params_to_rate")

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
