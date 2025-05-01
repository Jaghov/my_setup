{
  config,
  lib,
  pkgs,
  ...
}:

{
  ###### interface
  imports = [
    ./noisetorch.nix
  ];
  options = {
    vol_control.enable = lib.mkEnableOption "Enables Audio control";
  }; 

  config = {
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      jack.enable = true;

      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      wireplumber.enable = true;
    };
    environment.systemPackages = lib.mkIf config.vol_control.enable [ pkgs.pavucontrol ];
    
  };


}
