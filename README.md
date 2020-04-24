# Nixos sd image and mainline uboot for Odroid N2

> Suitable for a server. Make sure you have your UART.

Kernel patches sourced from the Armbian build.

Builds on the nix `release-20.03` branch.

### What's working

- RTC
- Boots from SD, USB (tested)
- ethaddr (MAC) if you hard code one, otherwise it will regenerate on boot.

### What's not working

- Resetting the network adapter (`ip link set eth0 down/up`) requires a reboot!
- WOL
- Booting from eMMC (not sure why it doesn't work, hardware partitions?, it's "supposed to work")
- Linux desktop acceleration (needs panfrost drivers?) (won't fix)

### Not tried

- Audio

### How to prepare a bootable drive.

Running `nix-build` links products under the `./result` folder. You will need to build an image and uboot and write them to a drive to boot.

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

Build uboot with an ethernet address configured otherwise you will get a new IP on every boot

`nix-build release.nix -A uboot --argstr ethaddr "00:11:22:33:44:55"`

Then `dd` it to the sd card (or usb or eMMC)

```
DEV=/dev/mmcblkX
UBOOT=result/u-boot.bin.sd.bin
dd if=$UBOOT of=$DEV conv=fsync,notrunc bs=512 skip=1 seek=1
dd if=$UBOOT of=$DEV conv=fsync,notrunc bs=1 count=444
sync
```

# References for guidance and patches

- Armbian
- LibreElec
- Hardkernel forums

