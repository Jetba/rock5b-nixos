{
  config,
  lib,
  ...
}: let
  inherit (config.nixpkgs) localSystem;
  selectedPlatform = lib.systems.elaborate "aarch64-linux";
  isCross = localSystem != selectedPlatform.system;
in (lib.mkIf isCross {
      # Some filesystems (e.g. zfs) have some trouble with cross (or with BSP kernels?) here.
      boot.supportedFilesystems = lib.mkForce ["vfat"];

      nixpkgs.crossSystem = builtins.trace ''
        Building with a crossSystem?: ${selectedPlatform.system} != ${localSystem.system} → ${
          if isCross
          then "we are"
          else "we're not"
        }.
               crossSystem: config: ${selectedPlatform.config}''
      selectedPlatform;
    })
