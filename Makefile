# make kernel_5_6
#
# make kernel_4_9 ARGS="--arg broken true"

TARGETS:=uboot sdImage kernel_4_9 kernel_5_4 kernel_5_5 kernel_5_6

print:
	@echo $(TARGETS) | tr ' ' '\n'

$(TARGETS):
	@nix-build release.nix -k -A $@ $(ARGS)

.PHONY: @(TARGETS)

