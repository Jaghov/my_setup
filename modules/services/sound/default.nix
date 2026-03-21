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
    rocksmith.enable = lib.mkEnableOption "Enables Audio control";
  }; 

  config = {
    users.users."dandy".extraGroups = lib.mkIf config.rocksmith.enable ["audio" "rtkit"];
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      jack.enable = true;

      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      wireplumber = {
        enable = true;
        extraConfig = {
          access.rules = [
          {
            # Removes electron apps' ability to change the mic gain by themselves.
            # check https://pipewire.pages.freedesktop.org/wireplumber/daemon/configuration.html for more info
            # and https://www.reddit.com/r/archlinux/comments/190dvl8/pipewirewayland_how_to_stop_applications_from/ for the source
            # of this fix
            matches = [ { application.process.binary = "electron"; }
             { application.process.binary = "vencord"; }];
            actions = { update-props = { default_permissions = "rx"; }; };
          }
            
            
          ];
        };
        
      };
    };
    environment.systemPackages = lib.mkIf config.rocksmith.enable [
      pkgs.crosspipe
      pkgs.rtaudio
    ];
    
  };


}
