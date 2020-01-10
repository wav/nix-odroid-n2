# Nixos sd image and mainline uboot for Odroid N2

> Suitable for a server. Make sure you have your UART.

### What's working

- RTC
- Boots from SD, USB (tested)
- ethaddr (MAC) if you hard code one, otherwise it will regenerate on boot.

### What's not working

- Linux desktop acceleration (needs panfrost drivers?).
- WOL :(
- Boots from eMMC (not sure why it doesn't work, hardware partitions?, it's "supposed to work")

### Status

Works for me. Provided as given.

### How to use this

1. Build an image (on an aarch64 or x86_64 box)

`nix-build release.nix -A sdImage`

Then `dd` it to an sd card (or usb or eMMC)

```
DEV=/dev/mmcblkX
IMG=./result/???/sd-image-odroid-n2.img
dd if=$IMG of=$DEV conv=fsync bs=4M
sync
```

2. Build a u-boot (x86_64 box only :S)

`nix-build release.nix -A uboot`

Then `dd` it to the sd card (or usb or eMMC)

```
DEV=/dev/mmcblkX
UBOOT=./result/???/fip/uboot.bin.sd.bin
dd if=$UBOOT of=$DEV conv=fsync,notrunc bs=512 skip=1 seek=1
dd if= of=$DEV conv=fsync,notrunc bs=1 count=444
sync
```

# References for guidance and patches

- Armbian
- LibreElec
- Hardkernel forums

