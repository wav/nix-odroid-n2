{ lib, config, pkgs, ... }:

{
  imports = [
    <nixpkgs/nixos/modules/installer/cd-dvd/sd-image-aarch64.nix>
    ./profile.nix
  ];

  system.stateVersion = "20.03"; # Did you read the comment?

  sdImage = {
    imageBaseName = "odroid-n2";
    #compressImage = false;
    populateFirmwareCommands = lib.mkOverride 0 '''';
  };
  
}
