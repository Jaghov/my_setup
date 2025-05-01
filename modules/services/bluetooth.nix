{lib, config, pkgs, ...}:

{
  options = {
    bluethooth.enable = lib.mkEnableOption "Enables bluetooth";
    blueman.enable = lib.mkEnableOption "Adds bluethooth manager";
  };
  
  config = lib.mkIf config.bluetooth.enable ({
    hardware.bluetooth.enable = true;
  } // lib.mkIf config.blueman.enable {
    environment.systemPackages = [ pkgs.blueman ];
    services.blueman.enable = true;
  });

}
