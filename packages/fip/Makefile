bl30.pkg: data/bl30.bin data/bl301.bin
	pkg --type bl30 --output $@ $^

bl2.pkg: data/bl2.bin data/acs.bin
	pkg --type bl2 --output $@ $^

bl30.30sig: bl30.pkg
	bl30sig --input $< --output $@

bl30.3sig: bl30.30sig
	bl3sig  --input $< --output $@

bl31.3sig: data/bl31.img
	bl3sig  --input $< --output $@

bl33.3sig: $(UBOOT)
	bl3sig  --input $< --output $@

bl2.2sig: bl2.pkg
	bl2sig  --input $< --output $@

u-boot.bin: bl2.2sig bl30.3sig bl31.3sig bl33.3sig data/ddr4_1d.fw data/ddr4_2d.fw data/ddr3_1d.fw data/piei.fw data/lpddr4_1d.fw data/lpddr4_2d.fw data/diag_lpddr4.fw data/aml_ddr.fw
	bootmk --output $@ \
	  --bl2 bl2.2sig --bl30 bl30.3sig --bl31 bl31.3sig --bl33 bl33.3sig \
	  --ddrfw1 data/ddr4_1d.fw   --ddrfw2 data/ddr4_2d.fw   --ddrfw3 data/ddr3_1d.fw     --ddrfw4 data/piei.fw \
	  --ddrfw5 data/lpddr4_1d.fw --ddrfw6 data/lpddr4_2d.fw --ddrfw7 data/diag_lpddr4.fw --ddrfw8 data/aml_ddr.fw

.phony: install

install: u-boot.bin
	install -m 644 u-boot.bin $(PREFIX)/u-boot.bin
	@echo ""
	@echo ">> Write the image to SD with"
	@echo ">> =========================="
	@echo ">> DEV=/dev/mmcblkX"
	@echo ">> dd if=fip/u-boot.bin of=\$$DEV conv=fsync,notrunc bs=512 seek=1"
	@echo ""