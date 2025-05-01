{lib, ...}:
{
  imports = [
    ./nvidia.nix
    ./opentabletdriver.nix
    ./vr.nix
  ];

  nvidia.enable = lib.mkDefault true;
  otd.enable = lib.mkDefault true;
  vr.enable = lib.mkDefault true;
  
  
}
