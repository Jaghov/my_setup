{lib, config, pkgs, ...}:

{
  options = {
    bluetooth.enable = lib.mkEnableOption "Enables bluetooth";
    blueman.enable = lib.mkEnableOption "Adds bluetooth manager";
  };
    config = lib.mkMerge [
    (lib.mkIf config.bluetooth.enable {
      hardware.bluetooth = {
      enable = true;
      package = pkgs.bluez-experimental;
      settings.Policy.AutoEnable = true;

    };
    })

    (lib.mkIf (config.bluetooth.enable && config.blueman.enable) {
      environment.systemPackages = [ pkgs.blueman ];
      services.blueman.enable = true;
    })
  ];
 

}
