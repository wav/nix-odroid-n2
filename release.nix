{ nixpkgs ? <nixpkgs>,
  ethaddr ? null,
  broken ? false,
}:

with (import nixpkgs {}).stdenv.lib;

let

  targetSystem = "aarch64-linux";

  sdImageConfig = import (nixpkgs+"/nixos/lib/eval-config.nix") {
     modules = [ 
       ./modules/sd-image.nix
       (if (targetSystem == builtins.currentSystem) then {}
       else ./cross.nix)
     ];
  };

  mkJob  = { select, system ? builtins.currentSystem }: select (import nixpkgs (
    if (targetSystem == system) then { inherit system; }
    else { crossSystem = targetSystem; }
  ));

  jobs = {

    kernel_5_4 = mkJob { select = pkgs: (pkgs.callPackage ./packages/linux_odroid_n2/linux-5.4.nix pkgs); };

    kernel_5_5 = mkJob { select = pkgs: (pkgs.callPackage ./packages/linux_odroid_n2/linux-5.5.nix pkgs); };

    kernel_5_6 = mkJob { select = pkgs: (pkgs.callPackage ./packages/linux_odroid_n2/linux-5.6.nix pkgs); };
  
  } // (optionalAttrs (builtins.currentSystem == "x86_64-linux") {

    # This cannot be built on aarch64 because the tool used to bind the blobs
    # and the built binary, aml_encrypt_g12b, is only available for the x86_64 arch.
    # Maybe, meson-tools' amlbootsig could be used instead
    uboot =  mkJob { select = pkgs: (pkgs.callPackage ./packages/uboot_odroid_n2/default.nix (pkgs // { inherit ethaddr; })); };

 }) // (optionalAttrs (broken) {
    
   kernel_4_9 = mkJob { select = pkgs: (pkgs.callPackage ./packages/linux_odroid_n2/linux-hardkernel-4.9.nix pkgs); };

  });
in
{
  inherit (sdImageConfig.config.system.build)
     toplevel
     sdImage;

} // jobs
