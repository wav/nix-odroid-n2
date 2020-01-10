{ nixpkgs ? <nixpkgs>,
  supportedSystems ? [ "aarch64-linux" ],
  ethaddr ? null
}:

let
  sdImageConfig = import (nixpkgs+"/nixos/lib/eval-config.nix") {
     modules = [ ./modules/sd-image.nix ];
  };

  mkJob  =
    { system ? builtins.currentSystem, select }:
	select (import nixpkgs { inherit system; });

  jobs = rec {

    # TODO investigate reusing overlay
    # kernel_5_4 = mkJob { select = pkgs: pkgs.linuxPackages_odroid_n2_5_4; };

    kernel_5_4 = mkJob { select = pkgs: (pkgs.callPackage ./packages/linux_odroid_n2/linux-5.4.nix pkgs); };

    kernel_5_5 = mkJob { select = pkgs: (pkgs.callPackage ./packages/linux_odroid_n2/linux-5.5.nix pkgs); };

    uboot = mkJob { 
        # This cannot be build on aarch64 because the tool used to bind the propierty blobs and the built binary, aml_encrypt_g12b, is only available for the x86_64 arch
        # Maybe, meson-tools' amlbootsig could be used instead
        system = "x86_64-linux";
	select = pkgs: (pkgs.callPackage ./packages/uboot_odroid_n2/default.nix (pkgs // { inherit ethaddr; }));
    };

  };
in
{
  inherit (sdImageConfig.config.system.build)
     # kernel # = kernel_5_5
     toplevel
     sdImage;

} // jobs
