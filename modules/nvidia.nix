{ config, lib, pkgs, ... }:

let
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec "$@"
  '';
in {
  ###### interface
  options = {
    nvidia.enable = lib.mkEnableOption "enables Blueman"; 
  };

  config = lib.mkIf config.nvidia.enable {
    environment.systemPackages = [ nvidia-offload ]; # Make sure this is a list

    hardware.nvidia = {
      modesetting.enable = true;
      powerManagement = {
        enable = false;
        finegrained = false;
      };
      open = false;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
      prime = {
        offload.enable = true;
        intelBusId = "PCI:12:0:0"; 
        nvidiaBusId = "PCI:1:0:0";
      };
    };
  };
}
