{ stdenv, callPackage, ubootTools, ... } @ args:

with (import ./patch/default.nix stdenv.lib);

callPackage ./configure.nix {

  inherit stdenv ubootTools;

  configfile = ./linux-5.4.config;

  kernel = callPackage <nixpkgs/pkgs/os-specific/linux/kernel/linux-5.6.nix> {
    kernelPatches = (patchsets [
      "armbian/5.6"
      "libre/5.4"
    ]);

    NIX_CFLAGS_COMPILE = toString [
      "-mcpu=native"
    ];
  };
}
