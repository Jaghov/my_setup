{
  config,
  lib,
  pkgs,
  ...
}:

{
  ###### interface
  options = {
    noisetorch.enable = lib.mkEnableOption "enables noisetorch"; # initialise config option for noisetorch
  };

  config = lib.mkIf config.noisetorch.enable {
    environment.systemPackages = [ pkgs.noisetorch ]; # Make sure this is a list
    programs.noisetorch.enable = true;

  };

}
