{lib, config, pkgs, ...}:

{
  options = {
    steam.enable = lib.mkEnableOption "Enable Steam";
  };

  config = lib.mkIf config.steam.enable {

  
    
    # Enable steam
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };
    hardware.steam-hardware.enable = true;
  };
}
