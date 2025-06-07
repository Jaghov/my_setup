{pkgs,...}:
{

  users.users.dandy.packages = with pkgs; [
    kdePackages.xwaylandvideobridge
    hyprland
    hyprpanel
    hyprland-qtutils
    rofi-wayland
  ];
  
  programs.xwayland.enable = true;


  # Handles desktop interactions
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    portalPackage = pkgs.xdg-desktop-portal-hyprland;
  };
  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.excludePackages = [ pkgs.xterm ];

  # Fonts for hyprpanel
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];
  fonts.fontDir.enable = true;

  # Enabling hyprland on Nixos
  environment.sessionVariables = {
    # If cursor becomes invisible
    WLR_NO_HARDWARE_CURSORS = "1";
    # Hint electron apps to use wayland
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
    GSK_RENDERER = "ngl";
    XDG_CURRENT_DESKTOP = "Hyprland";
  };
  
}
