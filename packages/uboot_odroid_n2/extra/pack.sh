#!/usr/bin/env bash

set -e

EXTRA_DIR=$(dirname "$(readlink -f "$BASH_SOURCE")")
PROJECT_DIR=$(dirname $EXTRA_DIR)

requiredFiles=(
    # tools
    fip/blx_fix.sh
    fip/aml_encrypt_g12b

    # firmware
    fip/bl301.bin
    fip/acs.bin
    fip/bl2.bin
    fip/bl30.bin
    fip/bl31.img
    fip/ddr3_1d.fw
    fip/ddr4_1d.fw
    fip/ddr4_2d.fw
    fip/diag_lpddr4.fw
    fip/lpddr4_1d.fw
    fip/lpddr4_2d.fw
    fip/piei.fw
    fip/aml_ddr.fw
)

for f in ${requiredFiles[@]}; do
    if [ ! -f "$EXTRA_DIR/$f" ]; then
        echo "$EXTRA_DIR/$f not found" >&2
        echo "look at re-pack.sh" >&2
        exit 1
    fi
done

if [ ! -f "${PROJECT_DIR}/u-boot.bin" ]; then
	echo "${PROJECT_DIR}/u-boot.bin not found" >&2
    echo "has the project been built? see build.sh"
	exit 1
fi

cd "${EXTRA_DIR}"

cp ${PROJECT_DIR}/u-boot.bin fip/bl33.bin

sh fip/blx_fix.sh \
	fip/bl30.bin \
	fip/zero_tmp \
	fip/bl30_zero.bin \
	fip/bl301.bin \
	fip/bl301_zero.bin \
	fip/bl30_new.bin \
	bl30

sh fip/blx_fix.sh \
	fip/bl2.bin \
	fip/zero_tmp \
	fip/bl2_zero.bin \
	fip/acs.bin \
	fip/bl21_zero.bin \
	fip/bl2_new.bin \
	bl2

fip/aml_encrypt_g12b --bl30sig --input fip/bl30_new.bin --output fip/bl30_new.tmp
fip/aml_encrypt_g12b --bl3sig --input fip/bl30_new.tmp  --output fip/bl30_new.bin.enc
fip/aml_encrypt_g12b --bl3sig --input fip/bl31.img      --output fip/bl31.img.enc
fip/aml_encrypt_g12b --bl3sig --input fip/bl33.bin      --output fip/bl33.bin.enc
fip/aml_encrypt_g12b --bl2sig --input fip/bl2_new.bin   --output fip/bl2.n.bin.sig
fip/aml_encrypt_g12b --bootmk \
		--output fip/u-boot.bin \
		--bl2 fip/bl2.n.bin.sig \
		--bl30 fip/bl30_new.bin.enc \
		--bl31 fip/bl31.img.enc \
		--bl33 fip/bl33.bin.enc \
		--ddrfw1 fip/ddr4_1d.fw \
		--ddrfw2 fip/ddr4_2d.fw \
		--ddrfw3 fip/ddr3_1d.fw \
		--ddrfw4 fip/piei.fw \
		--ddrfw5 fip/lpddr4_1d.fw \
		--ddrfw6 fip/lpddr4_2d.fw \
		--ddrfw7 fip/diag_lpddr4.fw \
		--ddrfw8 fip/aml_ddr.fw

echo "# Write the image to SD with"
echo DEV=/dev/mmcblkX
echo dd if=fip/u-boot.bin of=\$DEV conv=fsync,notrunc bs=512 seek=1
