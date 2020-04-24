#!/bin/sh

rm meson64-*/general-kernel-odroidn2-current.patch \
   meson64-dev/0450-arm64-dts-fix-IR-receiver-beelinkA1.patch \
   meson64-*/2000-drm-lima-simplify-driver-by-using-more-drm-helpers.patch \
   meson64-*/2001-drm-lima-devfreq-and-cooling-device-support.patch \
   meson64-current/media-meson-add-missing-allocation-failure-check-on-new_buf.patch \
   meson64-*/v2-clk-meson-pll-Fix-by-0-division-in-__pll_params_to_rate.patch \
   meson64-dev/crypto-amlogic-fix-removal-of-module.patch \
   meson64-*/update_entries_for_disabling_SS_instances_in_park_mode.patch \
   2>/dev/null

true
