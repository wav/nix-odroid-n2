{ lib, config, pkgs, ... }:

{
  imports = [
    <nixpkgs/nixos/modules/installer/cd-dvd/sd-image-aarch64.nix>
    ./packages.nix
  ];

  boot.kernelPackages = pkgs.linuxPackages_odroid_n2_5_4;
  boot.kernelParams = [
    "no_console_suspend"
    "consoleblank=0"
    "fsck.fix=yes"
    "fsck.repair=yes"
    "net.ifnames=0"
    "elevator=noop"
    "ethaddr=\${ethaddr}"
  ];

  boot.consoleLogLevel = lib.mkDefault 7;

  boot.supportedFilesystems = lib.mkForce [ "btrfs" "vfat" "cifs" ];

  system.stateVersion = "20.03"; # Did you read the comment?

  sdImage = {
    imageBaseName = "odroid-n2";
    #compressImage = false;
    populateFirmwareCommands = lib.mkOverride 0 '''';
  };
  
}
