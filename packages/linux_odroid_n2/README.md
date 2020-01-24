## How this kernel is prepared

1. Patches are copied from the the armbian/build repository. 
2. All patches that can be applied are kept.
3. All patches that break sources are removed.
   - currently audio

The linux config file was generated originally from a working armbian build then amended overtime.

The most significant, incomplete, config items that made nix bootable were:

```
MESON.*=y
# CONFIG_USB_UAS is not set
CONFIG_BLK_DEV_DM_BUILTIN=y
```

