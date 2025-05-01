{
  config,
  lib,
  pkgs,
  ...
}:

{
  ###### interface
  options = {
    otd.enable = lib.mkEnableOption "enables open tablet driver";
  };

  config = lib.mkIf config.otd.enable {
    hardware.opentabletdriver.enable = true;
  };

}
