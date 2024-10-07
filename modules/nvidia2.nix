{ config, pkgs, ... }:

{
  # Enable NVIDIA drivers
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;  # If you need 32-bit support
    extraPackages = with pkgs; [
      pkgs.libglvnd
    ];
  };

  # Enable CUDA support
  hardware.nvidia = {
    mksEnable = true;  # For OpenCL support, if needed
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # Optional: Specify the exact NVIDIA driver version
  # hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages_525;
}
