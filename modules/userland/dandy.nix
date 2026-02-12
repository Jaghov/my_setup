{lib, pkgs, ...}:
{

  imports = [
    # ./programs.nix
    ./steam.nix
  ];

  steam.enable = lib.mkDefault false;
  
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.dandy = {
    isNormalUser = true;
    description = "Joseph Aghoghovbia";
    extraGroups = [
      "networkmanager"
      "wheel"
      "tty"
      "dialout"
    ];
    packages = with pkgs; [
      firefox
      vivaldi
      tor-browser
      google-chrome
      obsidian

    ];
  };
}
