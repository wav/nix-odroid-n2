{ kernel,
  configfile,
  ubootTools,
  stdenv,
}:

with stdenv.lib;

let
    inherit (kernel) modDirVersion;

    # slightly modify default configurePhase to use our own config with 'allnoconfig'
    configuredKernel = (kernel // (derivation (kernel.drvAttrs // {
        configurePhase = ''
        runHook preConfigure
        mkdir build
        export buildRoot="$(pwd)/build"

        echo "manual-config configurePhase buildRoot=$buildRoot pwd=$PWD"
        if [ -f "$buildRoot/.config" ]; then
            echo "Could not link $buildRoot/.config : file exists"
            exit 1
        fi

        make $makeFlags "''${makeFlagsArray[@]}" mrproper
        make $makeFlags "''${makeFlagsArray[@]}" KCONFIG_ALLCONFIG=${configfile} allnoconfig
        
        runHook postConfigure
        make $makeFlags "''${makeFlagsArray[@]}" prepare
        actualModDirVersion="$(cat $buildRoot/include/config/kernel.release)"
        if [ "$actualModDirVersion" != "${modDirVersion}" ]; then
            echo "Error: modDirVersion ${modDirVersion} specified in the Nix expression is wrong, it should be: $actualModDirVersion"
            exit 1
        fi
        # Note: we can get rid of this once http://permalink.gmane.org/gmane.linux.kbuild.devel/13800 is merged.
        buildFlagsArray+=("KBUILD_BUILD_TIMESTAMP=$(date -u -d @$SOURCE_DATE_EPOCH)")
        cd $buildRoot
        '';
    })));
in 
overrideDerivation configuredKernel (old: {
    # make sure u-boot's tools are on the path so that 'kernel-odroidn2-current.patch' can use 'mkimage' for creating a dtbo
    # actually want "stdenv.hostPlatform.platform.kernelTarget", but don't know how to set it
    nativeBuildInputs = old.nativeBuildInputs ++ [ ubootTools ];
})
