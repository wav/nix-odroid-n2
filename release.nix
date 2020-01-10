{ nixpkgs ? <nixpkgs>,
  ethaddr ? null
}:

let
  targetSystem = "aarch64-linux";

  sdImageConfig = import (nixpkgs+"/nixos/lib/eval-config.nix") {
     modules = [ ./modules/sd-image.nix ];
  };

  mkJob  = { select, system ? builtins.currentSystem }: select (import nixpkgs (
	if (targetSystem == system)
        then { inherit system; }
	else { crossSystem = targetSystem; }
  ));

  jobs = rec {

    # TODO investigate reusing overlay
    # kernel_5_4 = mkJob { select = pkgs: pkgs.linuxPackages_odroid_n2_5_4; };

    kernel_5_4 = mkJob { select = pkgs: (pkgs.callPackage ./packages/linux_odroid_n2/linux-5.4.nix pkgs); };

    kernel_5_5 = mkJob { select = pkgs: (pkgs.callPackage ./packages/linux_odroid_n2/linux-5.5.nix pkgs); };

    uboot = (
        # This cannot be built on aarch64 because the tool used to bind the blobs
        # and the built binary, aml_encrypt_g12b, is only available for the x86_64 arch.
        # Maybe, meson-tools' amlbootsig could be used instead
        assert (builtins.currentSystem == "x86_64-linux");

	mkJob { select = pkgs: (pkgs.callPackage ./packages/uboot_odroid_n2/default.nix (pkgs // { inherit ethaddr; })); }
    );

  };
in
{
  inherit (sdImageConfig.config.system.build)
     # kernel # = kernel_5_5
     toplevel
     sdImage;

} // jobs
