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
      rocksmithPatch.enable = true;
      extraPackages = with pkgs; [ wineasio gamemode ]; # Adds wineasio
    };
    hardware.steam-hardware.enable = true;
  };
}
