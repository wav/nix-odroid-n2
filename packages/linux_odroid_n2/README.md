## How this kernel is prepared

1. Patches are from the armbian/build/patch/kernel/meson64-* directories
2. All patches that can be applied are kept (all ok)
3. All patches that break sources are removed (all ok)

The linux config file was generated originally from a working armbian build then amended overtime.

The most significant, incomplete, config items that made nix bootable were:

```
CONFIG_.*MESON.*=y
CONFIG_BLK_DEV_DM_BUILTIN=y
```

